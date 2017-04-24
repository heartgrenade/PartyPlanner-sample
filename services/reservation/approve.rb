class Reservation::Approve

  def self.call(reservation)
    reservation.approved!
    Notification::Create.call(reservation.user, reservation, :approved)
  end

end