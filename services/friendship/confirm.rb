class Friendship::Confirm

  def self.call(user, friend)
    if friendship = user.inverse_friendships.find_by(user_id: friend.id)
      friendship.confirm!
      Friendship::Notify.call(friendship)
    end
  end

end