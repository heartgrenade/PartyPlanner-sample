class Pusher::NotifyFriends

  def self.call(sender, type, user_ids)
    user_ids = user_ids.split(',') if user_ids.is_a?(String)
    user_ids = (user_ids.map(&:to_i) & sender.all_confirmed_friend_ids)

    User.where(id: user_ids).find_each do |user|
      I18n.locale = user.locale

      message  = I18n.t("pushes.#{type}")
      msg      = {
        type: type,
        from: sender.as_push_json,
        body: I18n.t("pushes.bodies.#{type}", nick: sender.nick)
      }

      Pusher::Push.build_and_send(user.device, message, msg, sender)
    end
  end

  def self.valid?(type, user_ids)
    type.in?(['fight', 'lost']) && user_ids.is_a?(Array)
  end

end