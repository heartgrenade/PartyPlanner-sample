class Fb::ValidateWithToken

  def self.call(token, uid)
    Fb::Api.new(token).me['id'].to_s == uid.to_s
  end

end