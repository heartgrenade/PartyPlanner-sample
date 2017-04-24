class Offer::NewOrder

  def self.call(offer, user)
    order = offer.orders.create!(user: user)
    Notification::Create.call(offer.author, order, :create)
    order
  end

end