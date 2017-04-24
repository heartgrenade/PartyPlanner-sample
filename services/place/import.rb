class Place::Import

  def self.existing
    Place.where(imported: true).find_each do |place|
      begin
        Event::Import.call(place)
      rescue => e
        puts "Place::Import Error importing place \##{place.id}: #{e.inspect}"
      end
    end
  end

  def self.fb_picture(place)
    object = Fb::Api.app_api.get_object(place.fb_id, fields: 'id,name,location,link,cover,about,phone')
    place.update_attributes({
      avatar: object['cover']['source']
    })
  end

  # fbid moze byc stringiem lub integerem
  def self.by_fb_id(fbid)
    object = Fb::Api.app_api.get_object(fbid, fields: 'id,name,location,link,cover,about,phone')

    place = Place.find_or_initialize_by(fb_id: object['id'])

    place.update_attributes!(
      name: object['name'],
      email: ( object['email'].presence || "#{object['id']}@facebook.com"),
      password: Devise.friendly_token[0..12],
      address: object['location'].try(:[],'street'),
      zip: object['location'].try(:[],'zip'),
      city: object['location'].try(:[],'city'),
      latitude: object['location'].try(:[],'latitude'),
      longitude: object['location'].try(:[],'longitude'),
      fb_url: object['link'],
      avatar: object['cover'].try(:[],'source'),
      description: object['about'],
      phone: object['phone'],
      imported: true,
      account_status: :approved,
      terms: true
    )
    Event::Import.call(place)
    place
  end

  def self.from_fb_url(url)
    u = Fb::Api.get_username_from_url(url)
    puts "from_fb_url: pobieram #{u} -> \t #{url}"
    begin
      by_fb_id(u)
    rescue => e
      puts "  -> err: #{e.inspect}"
    end
  end

  def self.from_fb_urls(urls=[])
    urls.each do |url|
      from_fb_url(url)
    end
  end

  def self.from_file(path_to_csv, col_sep: ',')
    imported = failed = 0

    CSV.read(path_to_csv, col_sep: col_sep).each do |line|
      # ["Sfinks700", "Mamuszki 1", "Sopot", "Poland", "81718", "54.44845988", "18.56726999", "188124841213156"]

      fbid = line.last
      puts "Pobieram \##{fbid}\t#{line[0]}"
      begin
        by_fb_id(fbid)
        imported += 1
      rescue => e
        puts " !!! BŁĄD: #{e.inspect}"
        failed += 1
      end

    end

    puts "Zakończyłem wczytując #{imported} lokali, przy #{failed} niepowodzeń"
  end

end
