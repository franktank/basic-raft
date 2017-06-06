class Leader
  def initialize(node)
    @node = node
  end

  def receive_entry(msg, followers)
    # Append entry in log, tells followers to append_entries
    @node.append_entry(msg)

    # Request all followers to append this entry
    append_count = 0
    followers.each do |follower|
      if follower.append_entry(msg) then append_count += 1 end
    end
  end
end
