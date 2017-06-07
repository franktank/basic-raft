describe "timer" do
  before { clock.stub }
  after { clock.reset }

  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let!(:f2) { NewNode.new(subject) }
  let!(:f3) { NewNode.new(subject) }
  let!(:clust) { [subject, f1, f2, f3] }
  let!(:followers) { [f1,f2,f3 ] }
  let!(:leader) { subject }

  context "follower timeout" do
    # start election
    it "starts an election on timeout" do
      # random between .15 and .3?
      EM.add_periodic_timer("random time") { f1.follower_timeout }
      clock.tick("random time")
      expect(f1).to receive(:follower_timeout)
    end
  end

  context "leader heartbeat" do
    before { subject.heartbeat }
    # maintain authority
    # should heartbeat happen endlessly?
    it "resets followers timeout" do
      # expect followers to reset timeout, so receive reset timer request

    end
  end

  context "candidate timeout" do
    # split vote
    it "starts a new election on timeout" do

    end
  end
end
