class Vip::Request

  def self.call(user, place)
    vip = place.vips.create!(user_id: user.id)
    #Notification::Create.call(place, vip, :create) if vip.valid?
    vip
  end

end