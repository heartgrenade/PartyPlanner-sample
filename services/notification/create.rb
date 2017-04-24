class Notification::Create

  def self.call(receiver, resource, action)
    receiver.notifications.create!(resource: resource, action: action)
  end

end