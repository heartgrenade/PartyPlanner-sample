class Place::NotifyExpiring

  def self.call(days: 7)
    Place.expiring_for(days).find_each do |place|
      I18n.locale = place.locale
      PlaceMailer.expiring_account(place, days).deliver
    end
  end

end