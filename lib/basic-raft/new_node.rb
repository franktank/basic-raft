class NewNode
  # Cluster
  # Role
  # Track who is leader, who is follower?
  # Leader / Follower Actions?


  cluster.each do |node|
    node.add_to_cluster(node)
  end

  def append_entry_request
    # based on role, perform different actions?

  end
end
