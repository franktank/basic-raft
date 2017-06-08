require_relative "../../../lib/basic-raft/new_node"

describe "election" do

  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let(:f2) { NewNode.new(subject) }
  let(:f3) { NewNode.new(subject) }
  let(:clust) { [subject, f1, f2, f3] }
  let(:followers) { [f1,f2,f3 ] }
  let(:leader) { subject }



  context "obtains majority votes" do
    it "becomes leader" do
      expect(subject.get_leader).to eq(subject)
    end

    before do
      followers.each do |f|
        allow(f).to receive(:append_entry)
      end
    end
    it "sends append entries to new followers" do
      new_leader = subject.get_leader
      # All new followers should have received :append_entry
    end

    it "everyone knows who the new leader is" do
      # expect everyone to return the same leader
    end

    it "new leader is not the same leader from past term" do
      # ??? is this true?
    end
  end

  context "another node becomes leader" do
    it "current node becomes follower" do
      pending "case not handled yet"
    end

    it "ends the current election" do
      pending "case not handled yet"
    end
  end

  # this is tested in heartbeat spec
  context "timeout from no leader" do
    it "starts a new election" do
      # expect
    end
  end
end
