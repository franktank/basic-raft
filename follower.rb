class Follower
  def initialize(node)
    @node = node
  end

  def append_entry(msg)
    # Save in log, return true if successful
    @node.log << msg ? true : false
  end

  def receive_entry(msg)
    # Redirect action to leader
    @node.metadata.leader.receive_entry(msg)
  end
end
