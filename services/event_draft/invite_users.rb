class EventDraft::InviteUsers

  def self.call(draft)
    draft.active! unless draft.active?
    draft.poll.invited_users.find_each do |user|
      draft.user.invite_to_draft!(user, draft)
    end if draft.poll_id?

    draft.invitations.find_each do |invitation|
      UserMailer.event_draft_invitation(draft, invitation).deliver
    end
  end

end