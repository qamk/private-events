class Event < ApplicationRecord
  has_many :invited_users, through: :invites
  belongs_to :host, class_name: 'User'

  validates :name, :location, :datetime, presence: true

  scope :located_in, ->(country) { where('location = ?', country) }
  scope :attending, ->(rsvp, event_id) { joins(:invites, :users).where(["invites.rsvp = ? AND events.id = ?", rsvp, event_id]) }

end
