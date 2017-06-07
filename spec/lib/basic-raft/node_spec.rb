require_relative "../../../lib/basic-raft/node"

describe Node do
  context "node is a leader" do
    let(:role) { double(:role) }
    let(:msg) { ' bar '}
    before do
      allow(Leader).to receive(:new).and_return(role)
    end
    subject { described_class.new }

    context '.receive_entry' do
      before { allow(role).to receive(:receive_entry) }
      before { subject.receive_entry(msg) }

      it 'passes thru to @role' do
        expect(role).to have_received(:receive_entry).with(msg, [])
      end
    end

    context '.append_entry' do
      before { subject.append_entry(msg) }

      it 'updates log' do
        expect(subject.send(:log)).to eq( [msg] )
      end
    end

    context '.add_follower' do
      before { subject.add_follower(follower) }
      let(:follower) { double(:follower) }
      it 'updates followers' do
        expect(subject.send(:followers)).to eq( [follower] )
      end
    end

    context '.redirect_message' do
      before { subject.redirect_message(msg) }

      it 'passes thru to @leader' do
        expect(subject).to have_received(:receive_entry).with(msg, followers)
      end
    end

  end
end
#
#
#
#   let(:log) { [] }
#   let(:msg) { ' bar '}
#   let(:role) { double(:role) }
#   let(:follower) { double(:follower) }
#   let(:followers) { [ follower ] }
#   let(:node) do
#     double(:node,
#       log: [],
#       followers: [],
#       role: role
#     )
#   end
#   let(:leader) { double(:leader) }
#   let(:follower_node) do
#     double(:follower_node,
#       log: [],
#       followers: [],
#       role: role,
#       leader: leader
#     )
#   end
#   subject(:f) { described_class.new(lead) }
#   subject(:lead) { described_class.new }
#
#   before { allow(role).to receive(:receive_entry) }
#   before { allow(leader).to receive(:receive_entry) }
#
#   context '.receive_entry' do
#     before { lead.receive_entry(msg) }
#
#     it 'passes thru to @role' do
#       expect(role).to have_received(:receive_entry).with(msg, followers)
#     end
#   end
#
#   context '.append_entry' do
#     before { lead.append_entry(msg) }
#
#     it 'updates log' do
#       expect(lead.log).to eq( [msg] )
#     end
#   end
#
#   context '.add_follower' do
#     before { lead.add_follower(follower) }
#
#     it 'updates followers' do
#       expect(lead.followers).to eq( [msg] )
#     end
#   end
#
#   context '.redirect_message' do
#     before { f.redirect_message(msg) }
#
#     it 'passes thru to @leader' do
#       expect(leader).to have_received(:receive_entry).with(msg, followers)
#     end
#   end
#
# end
#



# describe 'updating the log' do
#   let!(:f1) { Node.new(:follower, md) }
#   let!(:f2) { Node.new(:follower, md) }
#   let!(:f3) { Node.new(:follower, md) }
#   let!(:f4) { Node.new(:follower, md) }
#   let!(:lead) { Node.new(:leader, md) }
#
#   before {
#     lead.receive_entry('foo')
#     lead.receive_entry('bar')
#   }
#
#   it 'should update the network' do
#     [f1, f2, f3, f4].each do |f|
#       expect( f.send(:log) ).to eq %w(foo bar)
#     end
#   end
#
# end
#
#
# describe Follower do
# end
