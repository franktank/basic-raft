class Leader
  def initialize(node)
    @node = node
  end

  def receive_entry(msg)
    # Append entry in log, tells followers to append_entries
    @node.log << msg

    # Request all followers to append this entry
    append_count = 0
    @node.metadata.followers.each do |follower|
      if follower.role.append_entry(msg) then append_count += 1 end
    end
    if append_count >= @node.metadata.majority then @node.metadata.increment_commit_index end
  end
end
