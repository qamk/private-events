class Event < ApplicationRecord
  has_many :invited_users, through: :invites
  belongs_to :host, class_name: 'User'

  validates :name, :location, :datetime, presence: true
  validates :name, length: { minimum: 3, too_short: 'At least 3 characters please' }
  validates :description_length, length: {
    maximum: 45,
    too_long: "No more than 45 words. You currently have %{count}."
  }

  scope :event_location, ->(country) { where('location = ?', country) }
  scope :users_attending, ->(rsvp, event_id) {
      joins(:invites, :users).where(['invites.rsvp = ? AND events.id = ?', rsvp, event_id])
    }
  scope :for_page, ->(page, events_per_page) {
      order(created_at: :desc).offset(page * events_per_page).limit(events_per_page).includes(:host)
    }

  # Return the number of invited users -> Hash
  def self.num_attending(event_id)
    num_attending = self.joins(invites: :users).group('event.id').where('event.id = ?', event_id)
    event_id.nil? ? num_attending.unscope(:where) : num_attending
  end

  def description_length
    description.scan(/\w+/)
  end

end
