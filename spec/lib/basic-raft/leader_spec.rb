require_relative "../../../lib/basic-raft/leader"

describe Leader do
  let(:follower) {  double(:follower) }

  let(:node) do
    double(:node,
      log: [],
      followers: [ follower ]
    )
  end

  let(:followers) { [ follower ] }

  subject { described_class.new(node) }
  before { allow(follower).to receive(:append_entry) }
  before { allow(node).to receive(:append_entry) }

  context '.receive_entry' do
    let(:msg) { 'foo' }
    before { subject.receive_entry(msg, followers) }

    it 'updates all followers' do
      expect(follower).to have_received(:append_entry).with(msg)
    end

    it 'log to be updated' do
      expect(node).to have_received(:append_entry).with(msg)
    end
  end
end
