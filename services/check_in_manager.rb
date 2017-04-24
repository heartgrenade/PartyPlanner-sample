class CheckInManager

  def self.check_in!(user, place)
    user.check_ins.active.each(&:deleted!)
    place.check_ins.create!(user_id: user.id, checked_in_at: Time.current)
  end
end
