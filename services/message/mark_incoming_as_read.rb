class Message::MarkIncomingAsRead

  def self.call(to, messages = nil)
    coll = to.incoming_messages.unread
    # if messages.present?
    #   message_ids = messages.select{|m| m.read_at.nil? && m.to_id == to.id}.map(&:id)
    #   coll = coll.where(id: message_ids)
    # end
    coll.update_all(read_at: Time.current)
  end

end