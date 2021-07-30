class Invite < ApplicationRecord
  belongs_to :invited_user, class_name: 'User'
  belongs_to :event_invite, class_name: 'Event'

  validates :message_length, length: {  maximum: 20,
                                        too_long: "No more than 20 words. You have %{count}."
                                      }

  def message_length
    message.scan(/\w+/)
  end
end
