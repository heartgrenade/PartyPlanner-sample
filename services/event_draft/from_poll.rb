class EventDraft::FromPoll

  def self.build(poll)
    draft = EventDraft.new(
      name: poll.name,
      user: poll.user,
      place_id: poll.most_preferred_place.id,
      start_at: poll.most_preferred_start_at,
      budget_no: poll.most_preferred_budget_no,
      notes: poll.notes,
      contact: poll.contact
    )
  end

  def self.create(poll)
    draft = build(poll)
    draft.save!
    EventDraft::InviteUsers.call(draft)
  end

end