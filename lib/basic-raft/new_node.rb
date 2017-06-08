require 'timers'
require 'parallel'
class NewNode
  def initialize(leader = nil)
    @current_timer = Timers::Group.new
    @cluster = []
    @log = []
    @heartbeat_threads = []
    @timer_thread
    if leader
      @role = :follower
      leader.handle_new_cluster_member(self)
      start_timer
      p "TIMER"
    else
      @role = :leader
      add_to_cluster(self)
      heartbeat
      p "HEARTBEAT"
    end

    # constantly checking to see if its a leader?
    # or just do heartbeat in else, and during election run heartbeat on new leader
    # Thread.new do
    #   while true
    #     if role == :leader
    #       heartbeat
    #     end
    #   end
    end

  # end

  ###### Handling cluster ######

  def keep_cluster_unique
    @cluster.uniq!
  end

  def add_to_cluster(node)
    @cluster << node # node is new member
    keep_cluster_unique
  end

  def add_new_member(node)
    add_to_cluster(node)
    node.add_to_cluster(self)
    keep_cluster_unique
  end

  def handle_new_cluster_member(node)
    @cluster << node
    @cluster.each do |member|
      member.add_new_member(node)
    end
    keep_cluster_unique
  end

  ##################################


  ###### Finding followers and leaders ######

  def is_follower?
    @role == :follower
  end

  def is_leader?
    @role == :leader
  end

  def get_leader
    @cluster.each do |member|
      return member if member.is_leader?
    end
  end

  def get_followers
    followers = []
    @cluster.each do |member|
      followers << member if member.is_follower?
    end
    followers
  end

  #############################################

  ###### Node communication #######

  def receive_entry(msg)
    if @role == :leader
      append_entry(msg)
      followers = get_followers
      followers.each do |follower|
        follower.append_entry(msg)
      end
    elsif @role == :follower
      redirect_message_to_leader(msg)
    end
  end

  def redirect_message_to_leader(msg)
    leader = get_leader
    leader.receive_entry(msg)
  end

  def append_entry(msg = nil)
    if msg
      @log << msg
    else
      # Reset timer using parallel?
      reset_timer
      p "RESET TIMER CALLED"
    end
  end

  ################################
  # timer thread????
  ###### Timer ######

  def heartbeat
    # Just calls append_entry
    p "HEARTBEAT CALLED"
    @heartbeat_threads << Thread.new do
      while true
        followers = get_followers
        followers.each do |f|
          @heartbeat_threads << Thread.new do
            f.append_entry
            p "APPEND ENTRY CALLED"
          end
        end
      end
    end
  end

  def kill_heartbeat
    # End heartbeat by ending the loop
    p @heartbeat_threads
    @heartbeat_threads.each do |hbt|
      hbt.exit
      p "THREAD TERMINATED"
    end
    # End all f threads created too
  end

  def follower_timeout
    # Initiates election -> candidate and stuff
    p "Initiate election!"
  end

  def candidate_timeout
    # Starts new election
    p "Initiate another election!"
  end

  def node_timeout
    if @role == :leader
      p "Does nothing"
    elsif @role == :candidate
      p "Start new election"
    elsif @role == :follower
       "Start new election"
    else
      p "Unknown role"
    end
  end

  def reset_timer
    stop_timer
    start_timer
  end

  def start_timer
    # new_timer = Timers::Group.new
    # @current_timer = new_timer
    @timer_thread = Thread.new do
      new_timer = Timers::Group.new
      @current_timer = new_timer
      rnd = Random.new
      rnd_time = rnd.rand((15/100)..(30/100))
      p1 = new_timer.after(rnd_time) { node_timeout }
      @current_timer.wait
      p "TIMEOUT TRIGGERED"
    end
  end

  def stop_timer
    @current_timer.cancel
    @timer_thread.exit
  end

  ###################

  private

  attr_accessor :cluster, :log
end
