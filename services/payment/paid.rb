class Payment::Paid

  def self.call(payment)
    payment.transaction do
      payment.paid!
      if payment.account_extension?
        payment.payable.extend_validity_for!(payment.period.months)
        if payment.payer_type == 'User'
          User::ChangePlan.call(payment.payer, payment.details['plan'])
          User::ExpireFreemium.call(payment.payer)
        end
      elsif payment.event?
        Event::Paid.call(payment.payable_id)
      elsif payment.offer_order?
        Order::Paid.call(payment.payable)
      else
        raise "Payment::Paid: unknown paid_for: #{payment.paid_for}"
      end
    end
  end

end