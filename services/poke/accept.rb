class Poke::Accept

  def self.call(user, sender)
    if poke = user.inverse_pokes.find_by(from_id: sender.id)
      poke.accepted!
      Poke::Notify.call(poke)
    end
  end

end