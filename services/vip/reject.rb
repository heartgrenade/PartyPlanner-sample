class Vip::Reject

  def self.call(vip)
    vip.rejected!
    #Notification::Create.call(vip.user, vip, :rejected)
  end

end