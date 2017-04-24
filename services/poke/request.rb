class Poke::Request

  def self.call(user, recipient)
    poke = user.pokes.create!(to_id: recipient.id)
    Poke::Notify.call(poke)
  end

end