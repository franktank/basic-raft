require 'timers'
require 'parallel'

# @TODO How to handle election when new leader sends append entry during election
# @TODO Refactor to use request_vote_request, request_vote_response
class NewNode
  def initialize(leader = nil)
    @current_timer = Timers::Group.new
    @cluster = []
    @log = []
    @leader_alive = false
    @started_election = false # For case where append entry received from new leader during election
    @voted_for = nil
    @current_term = 1
    @timed_out = false
    if leader
      @role = :follower
      leader.handle_new_cluster_member(self)
      start_timer
    else
      @role = :leader
      add_to_cluster(self)
      heartbeat
    end
  end

  # end

  ### Handle term ###
  def get_current_term
    @current_term
  end
  ###################

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

  def append_entry(msg = nil, sender_term)
    # Return a boolean to say successful or not successful
    # Check for step down
    if @current_term < sender_term
      step_down(sender_term)
    end

    if @current_term > sender_term
      return @current_term, false
    end

    if msg
      @log << msg
    else
      # Reset timer using parallel?
      reset_timer
    end

    return @current_term, true
    # match index?
  end

  ################################

  ###### Timer ######

  def heartbeat
    # thread?
    Thread.new do
      @leader_alive = true
      while @leader_alive
        followers = get_followers
        followers.each do |f|
          f.append_entry
        end
        sleep 0.5
      end
    end
  end

  def kill_heartbeat
    # End all f threads created too
    @leader_alive = false
  end

  # @TODO: just one timeout for both cand and follower?
  def follower_timeout
    # Initiates election -> candidate and stuff
    p "Initiate election!"
    @role = :candidate
    start_election
    @timed_out = false
  end

  def candidate_timeout
    # Starts new election
    p "Initiate another election!"
    start_election
    @timed_out = false
  end

  def node_timeout
    if @role == :leader
      p "Does nothing"
    elsif @role == :candidate
      candidate_timeout
    elsif @role == :follower
      follower_timeout
    else
      p "Unknown role"
    end
  end

  def reset_timer
    stop_timer
    start_timer
  end

  def start_timer
    Thread.new do
      new_timer = Timers::Group.new
      @current_timer = new_timer
      rnd = Random.new
      rnd_time = rnd.rand((15/100)..(30/100))
      p1 = new_timer.after(2) do
         node_timeout
         @timed_out = true
      end
      @current_timer.wait
    end
  end

  def stop_timer
    @current_timer.cancel
  end

  ###################

  ####### Election Methods #######
  def start_election
    @started_election = true
    reset_timer
    @current_term += 1
    @voted_for = self
    num_votes = 1
    @cluster.each do |c|
      keep_requesting = true
      Thread.new do
        while keep_requesting
          if c != self
            ret_term, granted = vote_for(self)
            if ret_term
              # received response
              keep_requesting = false
            end
            if @current_term < ret_term
              step_down(ret_term)
            else
              if granted
                num_votes += 1
              end
            end
          else
            keep_requesting = false
          end
        end
      end
    end
    # Threads dont finish before num votes checked is call
    # How to handle this? is there delay to ensure or just timeout?
    # How to track when to count votes?
    # Handle timeout -> it shoud start new election if it doesnt receive votes in time
    p "cluster count: #{@cluster.count}"
    p "num_votes: #{num_votes}"
    while !@timed_out
      if num_votes > @cluster.count / 2
        leader = get_leader
        leader.revert_to_follower(self)
        become_leader
      end
    end
    @started_election = false
  end

  def revert_to_follower(node)
    if node.is_candidate?
      @role = :follower
    end
  end

  def become_leader
    bl = false
    if @role == :candidate
      bl = true
      @role = :leader
      followers = get_followers
      followers.each do |f|
        f.append_entry
      end
    end
    bl
  end

  def vote_for(node)
    # need to compare last_log_term and last_log_index
    vote_granted = false
    leader_term = node.get_current_term
    p "leader_term: #{leader_term}"
    p "self_term: #{@current_term}"
    if @current_term < leader_term
      p "Went in step down"
      step_down(leader_term)
    end
    # @TODO handle last log term and last log index
    if @current_term == leader_term
      if @voted_for == nil || @voted_for == node
        p "Went in vote granted"
        vote_granted = true
        @voted_for = node
        reset_timer
      end
    end

    return @current_term, vote_granted
  end
  ################################

  ##### Helper #####
  def step_down(term)
    @current_term = term
    @role = :follower
    @voted_for = nil
    reset_timer
  end

  def is_candidate?
    @role == :candidate
  end
  ##################

  private

  attr_accessor :cluster, :log, :voted_for
end
