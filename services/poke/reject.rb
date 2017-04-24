class Poke::Reject

  def self.call(user, sender)
    if poke = user.inverse_pokes.find_by(from_id: sender.id)
      poke.rejected!
      Poke::Notify.call(poke)
    end
  end

end