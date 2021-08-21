class InvitesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :grab_event, except: %i[show edit destroy update]
  before_action :grab_invite, except: %i[index new create]
  before_action :grab_event_by_id, only: %i[edit update]

  INVITES_PER_PAGE = 8

  # GET events/:event_id/invites
  def index
    @page = params.fetch(:page, 0).to_i
    @invites = Invite.invited(params[:event_id]).for_page(@page, INVITES_PER_PAGE)
    @older_invites = Invite.invited(params[:event_id]).for_page(@page + 1, INVITES_PER_PAGE)
  end

  # GET invites/:id
  def show
    redirect_to current_user unless invited_user?
  end

  # GET events/:event_id/invites/new
  def new
    redirect_to event_invites_url(@event) unless event_creator?
    @invite = Invite.new
    invited_user_ids = Invite.where(event_invite_id: @event).map(&:invited_user_id)
    @invited_users = User.all.where(id: invited_user_ids)
    @users = User.all.where.not(id: [@event.host] | invited_user_ids) # The Pipe is the Union Set Operator
  end

  # GET invites/:id/edit
  def edit
    redirect_to current_user unless invited_user?
  end

  # PUT invites/:id
  def update
    if @invite.update(update_invite_params) && invited_user?
      redirect_to current_user, notice: 'Success! The invite has been updated.'
    else
      flash.now[:error] = 'Failed to update invite'
      render :edit
    end
  end

  # POST events/:event_id/invites
  def create
    creation_params = create_invite_params
    creation_params[:invited_user] = User.find(creation_params[:invited_user].to_i)
    @new_invite = @event.invites.build(creation_params)
    if !duplicate_invite?(creation_params[:invited_user]) && @new_invite.save 
      redirect_to event_invites_url(@event), notice: 'Success! The invite has been created.'
    else
      flash[:error] = 'Failed to create new invite'
      redirect_to new_event_invite_path(@event)
    end
  end

  # DELETE invites/:id
  def destroy
    @invite.destroy
    redirect_to root, notice: 'Success! The invite has been deleted.'
  end

  protected

  def duplicate_invite?(invited_user)
    Invite.exists?(invited_user_id: invited_user)
  end

  def invited_user?
    @invite ||= grab_invite
    return false if @invite.nil?

    if @invite.invited_user == current_user
      true
    else
      flash[:error] = 'You are not authorised to perform this action'
      false
    end
  end
  helper_method :invited_user? # Gives method access to view

  def event_creator?
    @event ||= grab_event
    return false if @event.nil?

    if @event.host == current_user
      true
    else
      flash[:error] = 'You are not authorised to perform this action'
      false
    end
  end
  helper_method :event_creator?

  private

  def update_invite_params
    params.require(:invite).permit(:rsvp)
  end

  def create_invite_params
    params.require(:invite).permit(:message, :invited_user)
  end

  def grab_event
    @event = Event.find(params[:event_id])
  end

  def grab_invite
    @invite = Invite.where(id: params[:id]).includes(:invited_user).take
  end

  def grab_event_by_id
    @event = Event.where(id: @invite.event_invite).take
  end

end
