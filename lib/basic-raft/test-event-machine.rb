require 'eventmachine'
require 'timers'

# b = Thread.new do
#   em = EventMachine.run do
#     EM.add_periodic_timer(0.5) do
#       p '.1 seconds?'
#     end
#   end
# end
#
# a = Thread.new do
#   dog = EventMachine.run do
#     EM.add_periodic_timer(0.5) do
#       p 'BLAH seconds?'
#     end
#   end
# end
t1 = Timers::Group.new
t2 = Timers::Group.new

Thread.new do
  p Time.now
  p1 = t1.now_and_every(1) { p "LOL" }
  loop { t1.wait }
end

Thread.new do
  p Time.now
  p2 = t2.now_and_every(1) { p ":()" }
  loop { t2.wait }
end

# start_threads
sleep 2
t1.cancel
sleep 3
