class Push::MarkAsRead

  def self.call(pushes, user)
    Push.mark_as_read!(pushes, for: user)
    user.decrement!(
      :unread_pushes_count,
      [pushes.size, user.unread_pushes_count.to_i].min
    )
  end

end