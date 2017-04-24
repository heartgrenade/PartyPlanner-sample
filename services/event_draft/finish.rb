class EventDraft::Finish

  def self.call(draft)
    draft.finished!
    UserMailer.event_draft_finished(draft).deliver
  end

end