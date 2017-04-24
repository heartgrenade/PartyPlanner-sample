class Order::Paid

  def self.call(order)
    order.paid!
    Notification::Create.call(order.offer.author, order, :create)
    BaseMailer.order_created(order).deliver
    UserMailer.offer_order(order).deliver
  end

end