class Pusher::Initializer

  def self.call
    Pusher::Android.create_app
    Pusher::Ios.create_app
  end

end