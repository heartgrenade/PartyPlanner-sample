class Fb::Picture

  def self.get_link(fbid, height: 600, width: 600)
    JSON.parse(
      open("http://graph.facebook.com/#{fbid}/picture?redirect=0&height=#{height}&width=#{width}").read
    )['data']['url']
  end

end