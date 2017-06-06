require 'eventmachine'

EventMachine.run do
  EM.add_periodic_timer(0.01) do
    p '.1 seconds?'
  end
end
