class Fb::Api
  attr_reader :token

  def initialize(token)
    @token = token
  end

  def api
    @api ||= Koala::Facebook::API.new( token )
  end

  def me
    api.get_object('me')
  end

  def self.oauth
    @oauth ||= Koala::Facebook::OAuth.new(
      Rails.application.secrets.omniauth_facebook_key,
      Rails.application.secrets.omniauth_facebook_secret
    )
  end

  def self.exchange_access_token(token)
    oauth.exchange_access_token(token)
  end

  def self.app_api
    if fb_api_token = Setting.find_by_key('fb_api_token').try(:value)
      if @fb_api_token != fb_api_token
        @fb_api_token = fb_api_token
        @app_api = Koala::Facebook::API.new( @fb_api_token.presence || oauth.get_app_access_token )
      end
    else
      @app_api ||= Koala::Facebook::API.new( @fb_api_token.presence || oauth.get_app_access_token )
    end
    @app_api
  end

  def self.get_username_from_url(fb_url)
    fburl = fb_url.gsub(/((http|https)\:\/\/)|(www\.)|(facebook\.com\/)|(\?.+)/,'')
    if fburl.start_with?('pages')
      # "pages/MT-Club-Pub/551860258224283"
      fburl.split('/')[2]
    else
      fburl
    end
  end

  def self.get_fb_id_from_url(fb_url)
    Fb::Api.app_api.get_object(get_username_from_url(fb_url), fields: 'id,name,location,link,cover,about,phone')['id']
  end

end