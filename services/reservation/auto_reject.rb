class Reservation::AutoReject

  def self.call
    Reservation.pending.where('created_at <= ?', 24.hours.ago).find_each do |r|
      puts "Reservation::AutoReject -> rejecting \##{r.id}"
      Reservation::Reject.call(r)
    end
  end

end