class Event < ApplicationRecord
  has_many :invited_users, through: :invites
  has_many :invites, class_name: 'Invite', foreign_key: :event_invite_id
  belongs_to :host, class_name: 'User'

  validates :name, :location, :datetime, presence: true
  validates :name, length: { minimum: 3, too_short: 'At least 3 characters please' }
  validates :description_length, length: {
    maximum: 45,
    too_long: "No more than 45 words. You currently have %{count}."
  }
  validate :future_date_only

  # scope :event_location, ->(country) { where('location = ?', country) }
  scope :users_attending, ->(rsvp, event_id) {
      includes(:invited_user).where(['invites.rsvp = ? AND events.id = ?', rsvp, event_id])
    }
  scope :past, -> { where(['events.datetime < ?', Date.current.to_formatted_s(:db)]) }
  scope :for_page, ->(page, events_per_page) {
      where('events.datetime > ?', Date.current.to_formatted_s(:db))
        .order(created_at: :desc).offset(page * events_per_page).limit(events_per_page).includes(:host)
    }

  # Return the number of invited users -> Hash
  # def self.num_attending(event_id)
  #   num_attending = self.joins(:invites).group('event.id').where('event.id = ?', event_id)
  #   event_id.nil? ? num_attending.unscope(:where) : num_attending
  # end

  def description_length
    description&.scan(/\w+/)
  end

  def future_date_only
    if datetime && datetime < Date.current.to_formatted_s(:db)
      errors.add(:datetime, 'Cannot be in the past...')
    end
  end

end
