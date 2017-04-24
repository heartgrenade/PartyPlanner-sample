class Provider::Approve

  def self.call(provider)
    provider.approved!
    I18n.locale = provider.locale
    ProviderMailer.approved(provider).deliver
  end

end