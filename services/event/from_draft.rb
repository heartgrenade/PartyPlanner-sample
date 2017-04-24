class Event::FromDraft

  def self.call(draft)
    rv = nil
    event = draft.build_event(
      name: draft.name,
      organizer: draft.user,
      place: draft.place,
      start_at: draft.start_at,
      visibility: 'invited',
      draft: true,
      description: draft.notes,
      image: draft.image,
      latitude: draft.place.latitude,
      longitude: draft.place.longitude
    )
    if event.save
      draft.invitations.confirmed.update_all(event_id: event.id)

      draft.offers.each do |offer|
        offer.orders.create!(
          user_id: draft.user_id,
          event_draft_id: draft.id
        )
      end
      rv = event
    end
    rv
  end

end