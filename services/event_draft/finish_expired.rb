class EventDraft::FinishExpired

  def self.call
    EventDraft.active.where(valid_until: (2.days.ago.in_time_zone..Time.current)).find_each do |draft|
      EventDraft::Finish.call(draft)
    end
  end

end