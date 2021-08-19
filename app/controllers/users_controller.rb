class UsersController < ApplicationController
  before_action :authenticate_user!
  
  # GET /profile

  ITEMS_PER_PAGE = 4

  def show
    @page = params.fetch(:page, 0).to_i
    fetch_current_events
    fetch_past_events
    @show_next_page = max_length?(@hosting, @attending, @not_attending, @pending, @attended)
  end

  protected

  def fetch_current_events
    @hosting = Event.where(host_id: current_user).for_page(@page, ITEMS_PER_PAGE)
    @attending = Invite.user_invites(@page, ITEMS_PER_PAGE, current_user.id, 'true')
    @not_attending = Invite.user_invites(@page, ITEMS_PER_PAGE, current_user.id, 'false')
    @pending = Invite.user_invites(@page, ITEMS_PER_PAGE, current_user.id)
  end

  def fetch_past_events
    @attended = Invite.user_invites(0, 10, current_user.id, 'true', false)
    @hosted = Event.where(['events.host_id = ? AND events.datetime < ?', current_user, current_date])
                   .order(created_at: :desc).limit(10)
  end

  def rsvp_string(rsvp)
    rsvp.nil? ? 'None' : rsvp
  end
  helper_method :rsvp_string

  private

  def max_length?(*args)
    args.any? { |v| v&.length == ITEMS_PER_PAGE }
  end

  def current_date
    Date.current.to_formatted_s(:db)
  end

end
