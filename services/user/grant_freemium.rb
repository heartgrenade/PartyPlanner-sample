class User::GrantFreemium

  def self.call(user)
    user.freemium_granted_at = Time.current
    user.kind = 'p'
    user.save!
  end

end