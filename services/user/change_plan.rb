class User::ChangePlan

  def self.call(user, plan)
    if user.kind != plan && plan.in?(User.kinds)
      user.update_attributes!(kind: plan)
    end
  end

end