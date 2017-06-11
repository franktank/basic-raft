require_relative "../../../lib/basic-raft/new_node"


# @TODO Put in stuff related to log index, log term, commit index
describe "election" do

  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let!(:f2) { NewNode.new(subject) }
  let!(:f3) { NewNode.new(subject) }
  let(:clust) { [subject, f1, f2, f3] }
  let(:followers) { [f1,f2,f3 ] }
  let(:leader) { subject }



  context "obtains majority votes" do
    before { f1.node_timeout }
    it "becomes leader" do
      expect(subject.get_leader).to eq(f1)
    end

    before do
      clust.each do |c|
        allow(c).to receive(:append_entry)
      end
    end

    # Heartbeat establish authority and prevents new election
    it "sends append entries to new followers", focus: true do
      # All new followers should have received :append_entry
      f2.become_leader
      new_leader = f2.get_leader
      new_followers = new_leader.get_followers
      new_followers.each do |nf|
        expect(nf).to have_received(:append_entry)
      end
    end

    it "must have an up-to-date log" do
      pending "need to implement log replication / fix communication?"
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

  context "another node tries to become leader" do
    # Add step down in append_entry
    context "RPC term is larger than candidate's current term" do
      it "current node becomes follower" do
        f1.node_timeout
        # f1.append_entry, make it step down, etc
        pending "case not handled yet"
        expect(.is_follower?).to eq(true)
      end

      it "prevents current node from becoming leader" do
        pending "case not handled yet"
        # Basically changes role, then unable to become leader, since no longer candidate
        expect(become_leader).to eq(false)
      end
    end

    context "RPC term is smaller than candidate's current term" do
      it "remains a candidate" do
        # append entry does nothing?
        # is there response?
        # append entries response checks for term
        # scary changes coming up
      end

      it "other node steps down" do
        # the acclaimed leader realizes it should not be the leader and steps down
        # expect to receive :step_down
      end
    end
  end

  # this is tested in heartbeat spec
  # control from leader and one follower, kill leader
  # isnt this in timer spec?
  context "timeout from no leader" do
    it "starts a new election" do
      # expect to receive
    end
  end

  context "current leader dies" do
    it "starts a new election" do
      # from timeout
    end

    it "a new leader is chosen from the election" do
      # what if timeout from split vote?
    end
  end
end
