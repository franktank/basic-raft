require_relative "../../../lib/basic-raft/new_node"

describe "election" do
  context "obtains majority votes" do
    it "becomes leader" do

    end

    it "sends append entries to new followers" do

    end
  end

  context "another node becomes leader" do
    it "current node becomes follower" do

    end

    it "ends the current election" do

    end
  end

  context "timeout from no leader" do
    it "starts a new election" do
      
    end
  end
end
