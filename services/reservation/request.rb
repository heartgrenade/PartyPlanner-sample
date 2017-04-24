class Reservation::Request

  def self.call(user, place, params)
    parms = params.dup.symbolize_keys.merge(user_id: user.id)
    p parms
    reservation = place.reservations.create(parms)
    Notification::Create.call(place, reservation, :create)
    reservation
  end

end