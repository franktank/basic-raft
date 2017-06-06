class Node
  def initialize(leader=nil)
    # leader is a node passed in
    @followers = []
    @log = []
    if leader.nil?
      @leader = self
      @role = Leader.new(self)
    else
      @leader = leader
      leader.add_follower(self)
      @role = Follower.new(self)
    end
  end

  def add_follower(node)
    @followers << node
    @followers.each do |follower|
      follower.add_follower(node)
    end
  end

  def receive_entry(msg)
    @role.receive_entry(msg, @followers)
  end

  def append_entry(msg)
    @log << msg
  end

  def redirect_message(msg)
    @leader.receive_entry(msg, @followers)
  end

  private

  attr_accessor :log, :role, :followers
end


# how to track all the masters and slaves?
