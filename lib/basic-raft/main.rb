require './follower.rb'
require './leader.rb'
require './node.rb'
require './metadata.rb'

md = Metadata.new
l = Node.new('leader', md)
f1 = Node.new('follower', md)
f2 = Node.new('follower', md)
