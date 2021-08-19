class Invite < ApplicationRecord
  belongs_to :invited_user, class_name: 'User'
  belongs_to :event_invite, class_name: 'Event'

  validates :message_length, length: {
    maximum: 25,
    too_long: "No more than 25 words. You have %{count}."
  }
  validates :invited_user, uniqueness: { scope: :event_invite_id }

  scope :invited, ->(event_id) { where(event_invite_id: event_id) }
  scope :for_page, ->(page, invite_per_page) {
    order('invites.created_at DESC').offset(page * invite_per_page).limit(invite_per_page)
  }

  def message_length
    message&.scan(/\w+/)
  end

  # Returns events depending on rsvp status and date for a given page -> ActiveRecord::Relation
  def self.user_invites(page, per_page, user_id, rsvp = nil, future_only = true)
    future_invited_events = self.joins(:event_invite).where(invited_user_id: user_id, rsvp: rsvp)
                                .where(['events.datetime >= ?', Date.current.to_formatted_s(:db)])
                                .for_page(page, per_page).includes(:event_invite)
    past_invited_events = self.joins(:event_invite).where(invited_user_id: user_id, rsvp: rsvp)
                              .where(['events.datetime < ?', Date.current.to_formatted_s(:db)])
                              .for_page(page, per_page).includes(:event_invite)
    future_only ? future_invited_events : past_invited_events
  end

end
