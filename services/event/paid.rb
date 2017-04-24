class Event::Paid

  def self.call(event_id)
    raise 'event_id must be an integer' unless event_id.is_a?(Integer)

    event = Event.unscoped.find(event_id)

    event.update_attributes(draft: false)
    event.event_draft.orders.find_each do |order|
      Order::Paid.call(order)
    end

    event.event_draft.invitations.confirmed.find_each do |invitation|
      UserMailer.event_invitation(event, invitation).deliver
    end
  end

end