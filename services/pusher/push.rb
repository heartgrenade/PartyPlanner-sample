class Pusher::Push

  def self.send(push)
    if push.valid?
      Pusher::Android.push!(push)
      Pusher::Ios.push!(push)
    end
  end

  def self.build(devices_scope, message, data = {}, sender = nil)
    data[:body] = data[:body].truncate(1024) if data[:body].present?
    push = ::Push.new(message: message, data: data, type: data[:type])
    push.devices = devices_scope
    push.sender = sender
    push.save! unless push.message?
    push
  end

  def self.build_and_send(devices_scope, message, data = {}, sender = nil)
    send(build(devices_scope, message, data, sender))
  end

end