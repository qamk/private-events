class UsersController < ApplicationController
  before_action :authenticate_user!
  
  # GET /profile

  ITEMS_PER_PAGE = 4

  def show
    @page = params.fetch(:page, 0).to_i
    fetch_events
    @show_next_page = max_length?(@hosted, @attending, @not_attending, @pending, @attended)
  end

  protected

  def fetch_events
    @hosted = Event.where(host_id: current_user).for_page(@page, ITEMS_PER_PAGE)
    @attending = Invite.user_invites(@page, ITEMS_PER_PAGE, current_user.id, 'true')
    @not_attending = Invite.user_invites(@page, ITEMS_PER_PAGE, current_user.id, 'false')
    @pending = Invite.user_invites(@page, ITEMS_PER_PAGE, current_user.id)
    @attended = Invite.user_invites(@page, ITEMS_PER_PAGE, current_user.id, 'true', false)
  end

  def rsvp_string(rsvp)
    rsvp.nil? ? 'None' : rsvp
  end
  helper_method :rsvp_string

  private

  def max_length?(*args)
    args.any? { |v| v.length == ITEMS_PER_PAGE }
  end

end
