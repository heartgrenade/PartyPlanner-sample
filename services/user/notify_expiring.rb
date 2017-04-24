class User::NotifyExpiring

  def self.call(days: 7)
    User.paid_kinds.expiring_for(days).find_each do |user|
      I18n.locale = user.locale
      UserMailer.expiring_account(user, days).deliver
    end
  end

end