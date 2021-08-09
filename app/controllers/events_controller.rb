class EventsController < ApplicationController
  before_action :grab_event, except: %i[index destroy create]
  before_action :authenticate_user!, except: %i[index show]
  
  attr_accessor :event

  # GET / (root)
  def index
    @events = Event.all.includes(:host)
  end

  # GET /events/new
  def new
  end

  # GET /events/:id
  def show
    @attending = Event.attending(true, params[:id])
    @not_attending = Event.attending(false, params[:id])
    
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
    @new_event = current_user.events.build(event_params)
    if @new_event.save
      redirect_to @new_event, notice: 'New event registered!'
    else
      flash.now[:error] = 'Could not create event'
      render :new
    end
  end

  # DELETE /events/:id
  def destroy

  end

  private

  def grab_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :location, :datetime)
  end
end
