class EventsController < ApplicationController
  before_action :grab_event, except: %i[index create new]
  before_action :new_event, only: %i[index new]
  before_action :authenticate_user!, except: %i[index show]

  attr_accessor :event

  EVENTS_PER_PAGE = 4

  # GET / (root)
  def index
    @page = params.fetch(:page, 0).to_i # return :page from params or return 0
    @events = Event.for_page(@page, EVENTS_PER_PAGE).includes(:host)
    @older_events = Event.for_page(@page + 1, EVENTS_PER_PAGE)
    @past_events = Event.all.past
  end

  # GET /events/new
  def new
  end

  # GET /events/:id
  def show
    @users_attending = Event.users_attending(true, params[:id])
    @users_not_attending = Event.users_attending(false, params[:id])
  end

  # GET /events/:id/edit
  def edit
  end

  # PUT /events/:id
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Success! The event has been updated'
    else
      render :edit
    end
  end

  # POST /events
  def create
    @new_event = current_user.hosted_events.build(event_params)
    if @new_event.save
      redirect_to @new_event, notice: 'New event registered!'
    else
      flash[:error] = 'Could not create event'
      render :new
    end
  end

  # DELETE /events/:id
  def destroy
    @event.destroy
    redirect_to events_path, notice: 'Event Deleted'
  end

  private

  def new_event
    @event = Event.new
  end

  def grab_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :location, :datetime)
  end
end
