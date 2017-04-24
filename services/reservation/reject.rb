class Reservation::Reject

  def self.call(reservation)
    reservation.rejected!
    Notification::Create.call(reservation.user, reservation, :rejected)
  end

end