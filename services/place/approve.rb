class Place::Approve

  def self.call(place)
    place.approved!
    I18n.locale = place.locale
    PlaceMailer.approved(place).deliver
  end

end