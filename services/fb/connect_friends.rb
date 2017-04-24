class Fb::ConnectFriends

  # TODO do sidekiq?
  def self.call(user, token)
    api = Fb::Api.new(token)
    begin
      fbfriends = api.api.get_connections('me', 'friends')
      fbfriends.each do |fbfriend|
        if friend = User.find_by(uid: fbfriend['id'], provider: 'facebook')
          unless user.friend_with?(friend)
            user.friendships.create(friend_id: friend.id, confirmed_at: Time.current)
          end
        end
      end
    rescue => e
      Rails.logger.error "Fb::ConnectFriends: #{e.inspect}"
    end
  end

end