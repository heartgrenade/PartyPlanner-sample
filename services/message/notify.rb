class Message::Notify

  def self.call(message)
    I18n.locale = message.to.locale

    if message.to.connected?
      message.to.redis.publish(
        message.to.redis_key('message'),
        {
          from_id: message.from_id,
          from_nick: message.from.nick,
          body: message.body,
          unread_count: message.to.unread_chats_count
        }.to_json
      )
    else
      if message.to.device.try(:active?)
        msg = {
          type: 'message',
          from: message.from.as_push_json,
          message: message.as_push_json,
          body: "#{message.from.nick}: #{message.body.to_s.truncate(70)}"
        }
        Pusher::Push.build_and_send(message.to.device, message.body, msg, message.from)
      end
    end
  end

end