require_relative "../../../lib/basic-raft/new_node"
# @TODO FIGURE OUT HOW TO END SUBJECT / LEADER SO HEARTBEATS ARE OVER
# @TODO WHY ARENT FOLLOWERS RECEIVING APPEND ENTRY?
describe "timer" do

  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let(:f2) { NewNode.new(subject) }
  let(:f3) { NewNode.new(subject) }
  let(:clust) { [subject, f1, f2, f3] }
  let(:followers) { [f1,f2,f3 ] }
  let(:leader) { subject }


  # STUB A METHOD! Override is like we did for New!

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

  context "leader and follower timeout" do
    it "triggers timeout when cluster is a leader and a follower" do

    end

    it "a follower receives timeout when cluster is a leader and 3 followers" do

    end
  end

  context "candidate timeout" do
    # split vote
    it "starts a new election on timeout" do
      pending "candidate not implemented yet"
    end
  end
end
