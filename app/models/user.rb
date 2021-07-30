class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :hosted_events, foreign_key: :host_id, class_name: 'Event'
  has_many :event_invites, through: :invites
  has_many :received_invites, foreign_key: :invited_user_id, class_name: 'Invite'

  validates :email, :username, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
end
