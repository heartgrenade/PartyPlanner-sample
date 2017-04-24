class User::ReducePlan

  def self.one(user)
    user.kind = 'r'
    user.valid_until = nil
    user.save
  end

  def self.call
    User.paid_kinds.expired.each do |user|
      one(user)
    end
  end
  
end