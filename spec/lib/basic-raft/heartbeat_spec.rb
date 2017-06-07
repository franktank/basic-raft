require_relative "../../../lib/basic-raft/new_node"
# @TODO FIGURE OUT HOW TO END SUBJECT / LEADER SO HEARTBEATS ARE OVER
# @TODO WHY ARENT FOLLOWERS RECEIVING APPEND ENTRY?
describe "timer" do

  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let!(:f2) { NewNode.new(subject) }
  let!(:f3) { NewNode.new(subject) }
  let!(:clust) { [subject, f1, f2, f3] }
  let!(:followers) { [f1,f2,f3 ] }
  let!(:leader) { subject }


  # STUB A METHOD! Override is like we did for New!

  context "follower timeout" do
    # start election
    before { f1.start_timer }
    before do
      allow(f1).to receive(:node_timeout)
    end
    it "starts an election on timeout" do
      # HOW DO I END THE HEARTBEATS ??????? :(
      # Leader is alive and sending heartbeats so test fails?
      expect(f1).to have_received(:node_timeout)
      # expect(f1).to receive(:node_timeout)
      # expect(STDOUT).to receive(:puts).with('Start new election')
    end
  end

  context "leader heartbeat" do
    # Does the thread interfere with the test?
    # How do threads work with RSpec?
    # Printing in heartbeat appears in terminal

    before { subject.heartbeat }
    before do
      followers.each do |f|
        allow(f).to receive(:append_entry)
      end
    end

    it "resets followers timeout" do
      followers.each do |f|
        expect(f).to have_received(:append_entry)
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
