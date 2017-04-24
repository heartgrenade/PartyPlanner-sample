class Poll::Activate

  def self.call(poll)
    poll.active!
    poll.poll_replies.find_each do |reply|
      UserMailer.poll_invitation(reply).deliver
      Notification::Create.call(reply.user, reply, :invited)
    end
  end

end