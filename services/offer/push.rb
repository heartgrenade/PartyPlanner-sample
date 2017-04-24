class Offer::Push

  DISTANCE = 1

  class NotARealtime < StandardError
  end

  def self.call(offer)
    raise NotARealtime unless offer.realtime?

    offer.pushing!

    place = offer.place

    User.visible_on_map.with_current_coordinates.near([place.latitude, place.longitude], DISTANCE).find_each do |user|
      I18n.locale = user.locale

      message = I18n.t('pushes.offer', place_name: place.name)
      msg = {
        type: 'offer',
        place: place.as_push_json,
        offer: offer.as_push_json,
        body: I18n.t('pushes.bodies.offer', place_name: place.name)
      }

      Pusher::Push.build_and_send(user.device, message, msg, place)
    end

    offer.pushed!
  end

end