class Poke::Notify

  class UnprocessableStatus < StandardError
  end

  def self.call(poke)
    rcvr = if poke.pending?
      poke.to
    elsif poke.accepted?
      poke.from
    end
    I18n.locale = rcvr.locale

    dev, msg, snd = if poke.pending?
      [
        rcvr.device,
        I18n.t('pushes.bodies.poke.pending', nick: poke.from.nick),
        poke.from
      ]
    elsif poke.accepted?
      [
        rcvr.device,
        I18n.t('pushes.bodies.poke.accepted', nick: poke.to.nick),
        poke.to
      ]
    end
    return true unless dev.present?

    msg = {
      type: 'poke',
      from: poke.from.as_push_json,
      to: poke.to.as_push_json,
      poke: poke.as_push_json,
      body: msg
    }
    message = I18n.t("pushes.pokes.#{poke.status}")
    Pusher::Push.build_and_send(dev, message, msg, snd)
    true
  end

end