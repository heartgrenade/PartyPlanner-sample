class PpSeed

  def self.offers(limit = 10)
    Place.find_each do |place|
      offers_for(place, limit)
    end
  end

  def self.offers_for(place, limit = 10)
    limit.times do |n|
      s,e = n.days.from_now, (n+7).days.from_now
      place.offers.create!({
        name: "Oferta \##{n}",
        start_at: s,
        end_at: e,
        image: place.avatar,
        kind: (n%2==0 ? :realtime : :normal),
        special: (n%3==0),
        vip: (n%3==1)
      })
    end
  end

  def self.users(limit = 1000, force_ll: false, children_limit: 10)
    user_ids = []
    limit.times do |n|
      nick = User.build_nick("user#{n}")
      user = User.new({
        name: nick.upcase,
        nick: nick,
        email: "#{nick}@example.com",
        password: "userpass#{n}",
        confirmed_at: Time.current
      })
      if force_ll || n % 2 == 0
        user.latitude  = 50.0 + rand * 4
        user.longitude = 15.0 + rand * 8
      end
      user.save!
      user_ids << user.id
    end

    user_ids.each do |id|
      user = User.find(id)
      friendships_for(user, limit: children_limit)
      pokes_for(user, limit: children_limit)
      messages_for(user, limit: children_limit)
    end
  end

  def self.friendships_for(user, limit: 10)
    limit.times do |n|
      begin
        user2 = User.order('random()').first
      end while user == user2 || user.friend_with?(user2)
      Friendship.create!({
        user_id: user.id,
        friend_id: user2.id,
        confirmed_at: (n%2==0 ? Time.current : nil)
      })
    end
  end

  def self.pokes_for(user, limit: 10)
    limit.times do |n|
      begin
        user2 = User.order('random()').first
      end while user == user2 || user.friend_with?(user2) || user.poke_with?(user2)
      Poke.create!({
        from_id: user.id,
        to_id: user2.id,
        status: Poke.statuses.values[n%3]
      })
    end
  end

  def self.messages_for(user, limit: 10)
    uids = user.pokes.map(&:to_id) + user.inverse_pokes.map(&:from_id) + user.all_friend_ids
    limit.times do |n|
      user2 = User.where(id: uids.uniq).order('random()').first
      user.pokes.create(to_id: user2.id, status: 1) unless user.can_chat_with?(user2)
      10.times do |x|
        Message.create!({
          from_id: (x%2==0 ? user.id : user2.id),
          to_id: (x%2==0 ? user2.id : user.id),
          body: "Chat message #{n}"
        })
      end
    end
  end

  def self.range(min, max)
    rand * (max-min) + min
  end

  def self.rand_3city_coordinates
    [range(54.298, 54.523), range(18.49, 18.677)]
  end

  def self.relocate_users
    User.find_each do |x|
      ll=PpSeed.rand_3city_coordinates
      x.latitude=ll[0]
      x.longitude=ll[1]
      x.save!(validate: false)
    end unless Rails.env.production?
  end

end