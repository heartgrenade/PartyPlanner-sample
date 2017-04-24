class Fb::ExchangeApiToken

  def self.call
    if s = Setting.find_by_key('fb_api_token')
      t = Fb::Api.oauth.exchange_access_token(s.value)
      if t.present? && t != s.value
        s.update_column(:value, t)
      end
    end
  end

end