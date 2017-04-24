class Offer::PushRealtimes

  def self.call
    Offer.to_push_now.find_each{ |offer| Offer::Push.call(offer) }
  end

end
