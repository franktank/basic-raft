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
    before { f1.start_timer }
    it "starts an election on timeout" do
      # random between .15 and .3?
      # how to use start_timer here?
      sleep 2
      expect(f1).to have_received(:node_timeout)
      expect(f1).to receive(:node_timeout)
      expect(STDOUT).to receive(:puts).with('Start new election')
    end
  end

  context "leader heartbeat" do
    before { subject.heartbeat }
    # maintain authority
    # should heartbeat happen endlessly?
    it "resets followers timeout" do
      # expect followers to reset timeout, so receive reset timer request
      followers.each do |f|
        expect(f).to receive(:append_entry)
        expect(f).to receive(:reset_timer)
      end
    end
  end

  context "candidate timeout" do
    # split vote
    it "starts a new election on timeout" do

    end
  end
end
