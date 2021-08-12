class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @hosted = User.includes(:hosted_events)
    @invited_to = Invite.includes(:event_invite).where(invited_user_id: current_user.id)
  end
end
