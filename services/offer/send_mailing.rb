class Offer::SendMailing

  def self.call(offer)
    freshmail = Freshmail::Client.new(
      Rails.application.secrets.freshmail_api_key,
      Rails.application.secrets.freshmail_api_secret
    )
    user_ids = offer.place.favourited_user_ids + offer.place.vips.approved.map(&:user_id)
    User.where(id: user_ids.uniq).find_each do |user|
      next if user.email != 'kszczuka@gmail.com' && !Rails.env.production?

      I18n.locale = user.locale
      email = UserMailer.offer_mailing(offer, user)
      att = if Rails.env.production?
        Rails.application.routes.url_helpers.mailing_user_offers_url(
          host: AppCfg.host,
          token: offer.token,
          uid: user.secret_token,
          format: :pdf
        )
      else
        nil
      end

      r = freshmail.mail(
        from: AppCfg.mail.sender,
        subscriber: user.email,
        subject: email.subject,
        html: email.body.raw_source,
        attachments: att,
        tag: 'mailing ofert'
      )
      if r['status'] == 'OK'
        offer.users << user unless offer.users.exists?(user)
      else
        Rails.logger.error "Freshmail error: '#{r.inspect}'"
      end
    end
  end

end