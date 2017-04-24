class Friendship::Request

  def self.call(user, friend)
    friendship = user.friendships.create!(friend_id: friend.id)
    Friendship::Notify.call(friendship)
  end

end