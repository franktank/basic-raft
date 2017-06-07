require_relative "../../../lib/basic-raft/new_node"

describe "node interactions" do
  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let!(:f2) { NewNode.new(subject) }
  let!(:f3) { NewNode.new(subject) }
  let!(:clust) { [subject, f1, f2, f3] }
  let!(:followers) { [f1,f2,f3 ] }

  context "cluster membership information" do
    it 'everyone knows the followers' do
      clust.each do |c|
        expect(c.get_followers).to eq followers
      end

      expect(subject.get_followers).to eq followers
    end

    it 'everyone knows who is in the cluster' do
      clust.each do |c|
        expect(c.send(:cluster)).to eq clust
      end
    end

    it 'everyone recognize the leader' do
      followers.each do |f|
        expect(f.get_leader).to eq subject
      end

      expect(subject.get_leader).to eq subject
    end
  end

  context "leader receives an entry" do
    let(:msg) { 'foo' }
    before { subject.receive_entry(msg) }

    it "appends to its own log" do
      expect(subject.send(:log)).to eq ([msg])
    end

    it "sends request to followers to append to log" do
       followers.each do |follower|
         expect(follower.send(:log)).to eq ([msg])
       end
    end
  end

  context "followers receieves an entry" do
    let(:msg) { 'foo' }
    before { f1.receive_entry(msg) }
    it "redirects entry to leader" do
      followers.each do |follower|
        expect(follower.send(:log)).to eq ([msg])
      end
      expect(subject.send(:log)).to eq ([msg])
    end
  end
end
