class Message::MarkOutgoingAsRead

  def self.call(from, messages = nil)
    coll = from.messages.unread_by_sender
    # if messages.present?
    #   message_ids = messages.select{|m| !m.sender_read? && m.from_id == from.id}.map(&:id)
    #   coll = coll.where(id: message_ids)
    # end
    coll.update_all(sender_read: true)
  end

end