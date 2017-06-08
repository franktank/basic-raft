require_relative "../../../lib/basic-raft/new_node"
# @TODO Figure out how to test when multiple followers and leaders
# @TODO Set timer of one node to be lower so expect that to timeout?
# @TODO Best way to test?
describe "timer" do

  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let(:f2) { NewNode.new(subject) }
  let(:f3) { NewNode.new(subject) }
  let(:clust) { [subject, f1, f2, f3] }
  let(:followers) { [f1,f2,f3 ] }
  let(:leader) { subject }

  context "follower timeout" do
    # before { subject.kill_heartbeat }
    before do
      allow(f1).to receive(:node_timeout)
    end
    it "starts an election on timeout" do
      subject.kill_heartbeat
      sleep 2.1 # need to keep program running
      expect(f1).to have_received(:node_timeout)
    end
  end

  context "leader heartbeat" do
    # STUB A METHOD! Override is like we did for New!
    before do
      followers.each do |f|
        allow(f).to receive(:append_entry)
      end
    end

    it "resets followers timeout" do
      sleep 0.6
      followers.each do |f|
        expect(f).to have_received(:append_entry).at_least(1).times
      end
    end
  end

  context "candidate timeout" do
    # split vote
    it "starts a new election on timeout" do
      pending "candidate not implemented yet"
    end
  end
end
