class Vip::Approve

  def self.call(vip)
    vip.approved!
    #Notification::Create.call(vip.user, vip, :approved)
  end

end