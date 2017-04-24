class Message::Create

  def self.call(author, recipient, text)
    message = author.messages.create!(to_id: recipient.id, body: text)
    # TODO pusz/socket ping
    Message::Notify.call(message)
    true
  end

end