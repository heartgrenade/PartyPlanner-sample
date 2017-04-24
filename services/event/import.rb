class Event::Import

  class EmptyFbId < StandardError
  end

  def self.call(place, quiet: false)
    raise EmptyFbId if place.fb_id.blank?

    events = Fb::Api.app_api.get_connections(place.fb_id, 'events', fields: 'id,name,start_time,end_time,cover,description')
    events.each do |e|
      next if place.events.exists?(fb_id: e['id'])
      
      save(place, e, quiet: quiet)
    end if events.present?
  end

  # Event::Import.one(place, event.fb_id, force: true)
  def self.one(place, event_fb_id, force: false)
    raise EmptyFbId if place.fb_id.blank?
    events = Fb::Api.app_api.get_connections(place.fb_id, 'events', fields: 'id,name,start_time,end_time,cover,description')
    e = events.select{|e| e['id'].to_s == event_fb_id.to_s}.first
    p e
    save(place, e, force: force) if e
  end

  def self.save(place, e, force: false, quiet: false)
    return if e['start_time'].present? && e['end_time'].present? && ((e['end_time'].to_time - e['start_time'].to_time) > 4.days)

    puts "  -> wydarzenie: #{e['name']}" unless quiet

    event = place.events.find_or_initialize_by(fb_id: e['id'])
    event.name = e['name']
    event.organizer = place
    event.start_at = e['start_time']
    event.end_at = (e['end_time'].presence || (e['start_time'].to_time+8.hours))
    event.description = e['description']
    event.image = e['cover']['source'] if e['cover'].present?
    event.save
  end
end