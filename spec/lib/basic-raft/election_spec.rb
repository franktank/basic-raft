require_relative "../../../lib/basic-raft/new_node"


# @TODO Put in stuff related to log index, log term, commit index
describe "election" do

  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let(:f2) { NewNode.new(subject) }
  let(:f3) { NewNode.new(subject) }
  let(:clust) { [subject, f1, f2, f3] }
  let(:followers) { [f1,f2,f3 ] }
  let(:leader) { subject }



  context "obtains majority votes" do
    before { f1.start_election }
    it "becomes leader" do
      expect(subject.get_leader).to eq(f1)
    end

    before do
      clust.each do |c|
        allow(c).to receive(:append_entry)
      end
    end

    # Heartbeat establish authority and prevents new election
    it "sends append entries to new followers" do
      # All new followers should have received :append_entry
      f2.become_leader
      new_leader = f2.get_leader
      new_followers = new_leader.get_followers
      new_followers.each do |nf|
        expect(nf).to have_received(:append_entry)
      end
    end

    it "must have an up-to-date log" do
      pending "need to implement log replication"
    end

    it "everyone knows who the new leader is" do
      # expect everyone to return the same leader
      clust.each do |c|
        expect(c.get_leader).to eq(f1)
      end
    end

    it "received majority vote" do
      # expect the count to be greater than majority
      count = 1
      f1.get_followers.each do |f|
        if f.send(:voted_for) == f1
          count += 1
        end
      end
      expect(count).to > clust/2
    end

    it "each server voted for at most one candidate in the given term" do
      # ???
    end
  end

  context "another node becomes leader" do
    context "RPC term is larger than candidate's current term" do
      it "current node becomes follower" do
        pending "case not handled yet"
      end

      it "ends the current election" do
        pending "case not handled yet"
      end
    end

    context "RPC term is smaller than candidate's current term" do
      it "remains a candidate" do

      end
    end
  end

  # this is tested in heartbeat spec
  context "timeout from no leader" do
    it "starts a new election" do
      # expect
    end
  end

  context "current leader dies" do
    it "starts a new election" do

    end

    it "a new leader is chosen from the election" do

    end
  end
end
