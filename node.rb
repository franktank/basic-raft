class Node
  attr_accessor :log, :metadata, :role
  def initialize(r, md)
    if r == "leader"
      @role = Leader.new(self)
      md.set_leader(self)
    else
      @role = Follower.new(self)
      md.add_followers(self)
    end
    @log = []
    @metadata = md
  end

  def receive_entry(msg)
    @role.receive_entry(msg)
  end
end


# how to track all the masters and slaves?
