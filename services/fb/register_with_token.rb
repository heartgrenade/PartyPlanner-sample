class Fb::RegisterWithToken

  def self.call(token)
    me = Fb::Api.new(token).me

    user = User.new(provider: 'facebook', uid: me['id'])
    user.oauth_token = token
    user.password = Devise.friendly_token[0..12]
    user.name = (me['first_name'].presence || 'Imie')
    #user.nick = User.build_nick(me['first_name'])
    user.build_email_from_omniauth
    user.avatar = Fb::Picture.get_link(me['id'])
    user.save

    user
  end

end