class User::ExpireFreemium

  def self.call(user)
    user.update_column(:freemium_granted_at, nil) if user.freemium_granted_at?
  end

end