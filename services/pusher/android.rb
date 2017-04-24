class Pusher::Android
  APP_NAME = "pusher_android_app"

  def self.app
    @app ||= Rpush::Gcm::App.where(name: APP_NAME).first
  end

  def self.create_app
    return if app.present?
    app = Rpush::Gcm::App.new
    app.name = APP_NAME
    app.auth_key = Rails.application.secrets.pusher_gcm_key
    app.connections = 1
    app.save!
  end

  def self.push!(push)
    tokens = push.android_devices.map(&:token)
    if tokens.any?
      n = Rpush::Gcm::Notification.new
      n.app = app
      n.registration_ids = tokens
      n.data = {
        message: (push.data['body'] || push.message).truncate(1024),
        data: push.data.merge('id' => push.id)
      }
      n.save!
    end
    true
  end

end