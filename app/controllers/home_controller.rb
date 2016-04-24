class HomeController < ApplicationController
	before_filter :authenticate_user!
  	before_filter :ensure_admin, :only => [:edit, :destroy]
  	before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
  	@events = Event.all

    if params[:search]
      @events = Event.search(params[:search]).order("created_at DESC")
    else
      @events = Event.all.order('created_at DESC')
    end
  end

  def ensure_admin
    unless current_user && current_user.admin?
      render :text => "Access Error Message", :status => :unauthorized
    end
  end

  def new
    @event = Event.new
  end

    def create
    @event = Event.new(event_params)

    @event.ename = params[:event][:ename]
    @event.edescription = params[:event][:edescription]
    @event.etime = params[:event][:etime]
    @event.ecost = params[:event][:ecost]

    #myEvent = BasicEvent.new(@event.ename, @event.edescription, @event.etime, @event.ecost)

    logger = NewEventLogger.instance
    logger.logInformation("New Event added: #{@event.ename}, #{@event.edescription}, #{@event.etime}, #{@event.ecost}")

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
end
