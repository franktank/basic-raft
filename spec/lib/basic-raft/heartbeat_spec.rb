describe "timer" do
  include RSpec::EM::FakeClock

  before { clock.stub }
  after { clock.reset }

  context "follower timeout" do
    # start election
    it "starts an election on timeout" do

    end
  end

  context "leader heartbeat" do
    # maintain authority
    it "resets followers timeout" do

    end
  end

  context "candidate timeout" do
    # split vote
    it "starts a new election on timeout" do
      
    end
  end
end
