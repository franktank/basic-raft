class Metadata
  attr_accessor :leader, :followers, :majority
  def initialize
    @leader = nil
    @followers = []
    @majority = (@followers.count + 1)/2
    @commit_index = -1
  end

  def increment_commit_index
    @commit_index += 1
  end

  def set_leader(node)
    @leader = node
  end

  def add_followers(node)
    @followers << node
  end
end

# require './follower.rb'
# require './leader.rb'
# require './node.rb'
# require './metadata.rb'
