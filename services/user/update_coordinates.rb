class User::UpdateCoordinates

  def self.call(user, lat, lon)
    user.update_columns(
      latitude: lat,
      longitude: lon,
      coordinates_updated_at: Time.current
    )
    # TODO check_out_if_required(user)
  end

end