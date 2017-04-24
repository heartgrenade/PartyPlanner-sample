class Message::MarkOutgoingAsDeleted

  def self.call(user, contact)
    user.messages.from_undeleted
      .where(to_id: contact.id).update_all(from_deleted: true)
  end

end