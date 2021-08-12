class InvitesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :grab_event, except: %i[show edit destroy]
  before_action :grab_invite, except: %i[index new create]

  INVITES_PER_PAGE = 8

  # GET events/:event_id/invites
  def index
    @page = params.fetch(:page, 0).to_i
    @invites = Invite.invited(params[:event_id]).for_page(@page, INVITES_PER_PAGE)
    @older_invites = Invite.invited(params[:event_id]).for_page(@page + 1, INVITES_PER_PAGE)
  end

  # GET invites/:id
  def show
  end

  # GET events/:event_id/invites/new
  def new
    redirect_to event_invites_url(@event) unless event_creator?
    @invite = Invite.new
    @users = User.all.where.not(id: [@event.host.id])
  end

  # GET invites/:id/edit
  def edit
    redirect_to event_invites_url(@invite) unless invited_user?
  end

  # PUT invites/:id
  def update
    if @invite.update(update_invite_params) && invited_user?
      redirect_to event_invites_url(@event), notice: 'Success! The invite has been updated.'
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
    if @new_invite.save
      redirect_to event_invites_url(@event), notice: 'Success! The invite has been created.'
    else
      flash.now[:error] = 'Failed to create new invite'
      render :new
    end
  end

  # DELETE invites/:id
  def destroy
    @invite.destroy
    redirect_to root, notice: 'Success! The invite has been deleted.'
  end

  protected

  def invited_user?
    @invite ||= grab_invite
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
    @invite = Invite.find(params[:id]).includes(:users)
  end

end
