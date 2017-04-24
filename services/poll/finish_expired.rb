class Poll::FinishExpired

  def self.call
    Poll.active.where(replies_until: (2.days.ago.in_time_zone..Time.current)).find_each do |poll|
      Poll::Finish.call(poll)
    end
  end

end