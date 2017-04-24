class Friendship::Notify

  def self.call(friendship)
    rcvr = if friendship.pending?
      friendship.friend
    else
      friendship.user
    end
    I18n.locale = rcvr.locale

    dev, msg, bdy, snd = if friendship.pending?
      [
        rcvr.device,
        I18n.t('pushes.friendships.pending'),
        I18n.t('pushes.bodies.friendship.pending', nick: friendship.user.nick),
        friendship.user
      ]
    else
      [
        rcvr.device,
        I18n.t('pushes.friendships.confirmed'),
        I18n.t('pushes.bodies.friendship.confirmed', nick: friendship.friend.nick),
        friendship.friend
      ]
    end

    data = {
      type: 'friendship',
      user: friendship.user.as_push_json,
      friend: friendship.friend.as_push_json,
      friendship: friendship.as_push_json,
      body: bdy
    }
    Pusher::Push.build_and_send(dev, msg, data, snd)

    Notification::Create.call(rcvr, friendship, (friendship.pending? ? :create : :confirmed))

    true
  end

end