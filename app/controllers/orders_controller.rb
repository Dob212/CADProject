require 'open_weather'
require 'new_order_logger'
require 'order_decorator'

class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
    @profile = Profile.find(current_user.id)

    @orders = @profile.orders
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @profile = Profile.find_by_user_id(current_user.id)
    
    @options = { units: "metric", APPID: '58d05a1cb6c05328945b2f9f3de5ff72' }
    #City id or name can be acquirred from a database, i did not
    #have time to do this but once done this is how it would retrieve weather
    @city_id = "7778677"
    #@data = OpenWeather::Current.city("Dublin, IE", @options)
    @data = OpenWeather::Current.city_id(@city_id, @options)
    puts @data
    puts @data.keys

    @json = JSON.parse(@data.to_json)
    @temp = @json['main']['temp']
    @city = @json['name']
    @description = @json['weather'][0]['description']
  end

  # GET /orders/new
  def new
    @events = Event.all
    @profile = Profile.find(params[:profile_id])
    @order = @profile.orders.build 
    @event = Event.find_by ename: params[:param2]
    @order.oname = @event.ename
    @order.odescription = @event.edescription
    @order.otime = @event.etime
    @order.ocost = @event.ecost
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @profile = Profile.find(params[:order][:profile_id])

    @order.oname = params[:order][:oname]
    @order.odescription = params[:order][:odescription]
    @order.otime = params[:order][:otime]
    @order.ocost = params[:order][:ocost]

    myOrder = BasicOrder.new(@order.oname, @order.odescription, @order.otime, @order.ocost)

    if params[:order][:food].to_s.length > 0 then
      myOrder = FoodDecorator.new(myOrder)
    end

    if params[:order][:travel].to_s.length > 0 then
      myOrder = TravelDecorator.new(myOrder)
    end

    @order.ocost = myOrder.ocost
    @order.odescription = myOrder.details

    logger = NewOrderLogger.instance
    logger.logInformation("New Order by user #{@profile.firstname} #{@profile.lastname}: #{@order.oname}, #{@order.odescription}, #{@order.otime}, #{@order.ocost}")

    #puts "ocost from @order.ocost: #{@order.ocost}"
    #puts "odescription from @order.od: "+@order.odescription

    respond_to do |format|
      if @order.save
        format.html { redirect_to profile_order_url(@profile,@order), notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy

    @profile = Profile.find(params[:profile_id])
    @order = Order.find(params[:id])
    @order.destroy
    respond_to do |format|
      format.html { redirect_to profile_orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:oname, :odescription, :otime, :ocost, :profile_id)
    end
end
