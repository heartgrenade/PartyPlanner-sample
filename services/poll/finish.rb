class Poll::Finish

  def self.call(poll)
    poll.finished!
    UserMailer.poll_finished(poll).deliver
  end

end