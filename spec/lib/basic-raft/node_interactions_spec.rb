require_relative "../../../lib/basic-raft/new_node"

describe "node interactions" do
  subject { NewNode.new }
  let!(:f1) { NewNode.new(subject) }
  let!(:f2) { NewNode.new(subject) }
  let!(:f3) { NewNode.new(subject) }
  let!(:clust) { [subject, f1, f2, f3] }
  let!(:followers) { [f1,f2,f3 ] }

  it 'everyone knows the followers' do
    expect(subject.get_followers).to eq followers
    clust.each do |c|
      expect(c.get_followers).to eq followers
    end
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
