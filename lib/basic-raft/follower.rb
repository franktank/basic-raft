class Follower
  def initialize(node)
    @node = node
  end

  def receive_entry(msg, followers)
    # Redirect action to leader
    @node.redirect_message(msg)
  end
end
