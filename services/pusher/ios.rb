class Pusher::Ios
  APP_NAME = "pusher_ios_app"

  def self.app
    @app ||= Rpush::Apns::App.where(name: APP_NAME).first
  end

  def self.create_app
    return if app.present?
    app = Rpush::Apns::App.new
    app.name = APP_NAME
    app.certificate = File.read(Rails.application.secrets.pusher_apns_pem)
    app.environment = 'production'
    app.password = Rails.application.secrets.pusher_apns_password
    app.connections = 1
    app.save!
  end

  def self.push!(push)
    tokens = push.ios_devices.map(&:token)
    tokens.each do |token|
      n = Rpush::Apns::Notification.new
      n.app = app
      n.device_token = token
      n.alert = (push.data['body'] || push.message).truncate(1024)
      n.data = push.data.merge('id' => push.id)
      n.save!
    end if tokens.any?
  end

end