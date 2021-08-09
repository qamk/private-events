class InvitesController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :grab_event, except: %i[show edit destroy]
  before_action :grab_invite, except: %i[index]

  # GET events/:event_id/invites
  def index
    @invited = Invite.invited(params[:event_id]).select(:username)
  end

  # GET invites/:id
  def show
  end

  # GET events/:event_id/invites/new
  def new
    redirect_to events_invites_path(@event) unless event_creator?
  end

  # GET invites/:id/edit
  def edit
    redirect_to events_invites_path(@invite) unless invited_user?
  end

  # PUT invites/:id
  def update
    if @invite.update(update_invite_params) && invited_user?
      redirect_to events_invites_path(@event), notice: 'Success! The invite has been updated.'
    else
      render :edit
    end
  end

  # POST events/:event_id/invites
  def create

  end

  # DELETE invites/:id
  def destroy
  end

  protected

  def invited_user?
    grab_invite
    if @invite.invited_user == current_user
      true
    else
      flash.now[:error] = 'You are not authorised to perform this action'
      false
    end
  end
  helper_method :invited_user? # Gives method access to view

  def event_creator?
    grab_event
    if @event.host == current_user
      true
    else
      flash.now[:error] = 'You are not authorised to perform this action'
      false
    end
  end
  helper_method :event_creator?

  private

  def update_invite_params
    params.require(:invite).permit(:rsvp)
  end

  def create_invite_params
    params.require(:invite).permit(:message, :invited_user_id, :event_invite_id)
  end

  def grab_event
    @event = Event.find(params[:event_id])
  end

  def grab_invite
    @invite = Invite.find(params[:id])
  end

end
