class Provider::NotifyExpiring

  def self.call(days: 7)
    Provider.expiring_for(days).find_each do |provider|
      I18n.locale = provider.locale
      ProviderMailer.expiring_account(provider, days).deliver
    end
  end

end