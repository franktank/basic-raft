class NewNode
  def initialize(leader = nil)
    @current_timer = Timers::Group.new
    @cluster = []
    @log = []
    if leader
      @role = :follower
      leader.handle_new_cluster_member(self)
    else
      @role = :leader
      add_to_cluster(self)
    end
  end

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
    end
  end

  ################################
  # timer thread????
  ###### Timer ######

  def heartbeat
    # Just calls append_entry
    while true
      # Thread for each follower?
      # Reset time for each follower
    end
  end

  def follower_timeout
    # Initiates election -> candidate and stuff

  end

  def candidate_timeout
    # Starts new election
  end

  def node_timeout
    if role == :leader
      p "Does nothing"
    elsif role == :candidate
      p "Start new election"
    elsif role == :follower
      p "Start new election"
    end
  end

  def reset_timer
    stop_timer
    start_timer
  end

  def start_timer
    rnd = Random.new
    rnd_time = rnd.rand((15/100)..(30/100))
    EventMachine.run do
      EM.add_timer(rnd_time) { node_timeout }
    end
  end

  def stop_timer
    @current_timer.cancel
  end

  ###################

  private

  attr_accessor :cluster, :log
end
