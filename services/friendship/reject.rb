class Friendship::Reject

  def self.call(user, friend)
    user.friendship_with(friend).destroy
  end

end