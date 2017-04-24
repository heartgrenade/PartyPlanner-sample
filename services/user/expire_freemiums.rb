class User::ExpireFreemiums

  def self.call
    User.paid_kinds.freemiums.expired.find_each do |user|
      User::ExpireFreemium.call(user)
      User::ChangePlan.call(user, 'r')
    end
  end

end