class Reservation::Cancel

  def self.call(reservation)
    reservation.canceled!
    Notification::Create.call(reservation.place, reservation, :canceled)
  end

end