class Invite < ApplicationRecord
  belongs_to :invited_user, class_name: 'User'
  belongs_to :event_invite, class_name: 'Event'

  validates :message_length, length: {
    maximum: 25,
    too_long: "No more than 25 words. You have %{count}."
  }
  scope :invited, ->(event_id) { joins(:users).where(event_invite_id: event_id) }
  scope :for_page, ->(page, invite_per_page) {
    order('invites.created_at DESC').offset(page * invite_per_page).limit(invite_per_page)
  }
  def message_length
    message.scan(/\w+/)
  end
end
