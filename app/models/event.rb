class Event < ApplicationRecord
  has_many :invited_users, through: :invites
  belongs_to :host, class_name: 'User'

  validates :name, :location, :datetime, presence: true
end
