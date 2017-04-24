class Message::MarkIncomingAsDeleted

  def self.call(user, contact)
    user.incoming_messages.to_undeleted
      .where(from_id: contact.id).update_all(to_deleted: true)
  end

end