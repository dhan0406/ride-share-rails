class TripsController < ApplicationController
  
  def index
    driver_id = params[:driver_id]
    passenger_id = params[:passenger_id]
    
    if driver_id.nil? && passenger_id.nil?
      @trips = Trip.all
    elsif driver_id.nil?
      @passenger = Passenger.find_by(id: passenger_id)
      if @passenger
        @trips = @passenger.trips
      else
        head :not_found
      end
    else
      @driver = Driver.find_by(id: driver_id)
      if @driver
        @trips = @driver.trips
      else
        head :not_found
      end
    end
  end
  
  def show
    @trip = Trip.find_by(id: params[:id])

    if @trip.nil?
      redirect_to tasks_path
      return
    end
  end

  def new
    passenger_id = params[:passenger_id]
    driver_id = params[:driver_id]
    @trip = Trip.new
    
    if passenger_id.nil?
      @passengers = Passenger.all
    else
      @passengers = [Passenger.find_by(id: passenger_id)]
    end
    
    if driver_id.nil? 
      @drivers = Driver.all
    else
      @drivers = [Driver.find_by(active: nil)]
    end
  end
  
  def create 
    # will not set params for price, rating. by leaving it blank, it'll default to nil
    puts "meow trip create method"
    driver_id = params[:trip][:driver_id]
    passenger_id = params[:trip][:passenger_id]
    @trip = Trip.new( driver_id: driver_id, passenger_id: passenger_id, date: Time.now )
    puts params
    if @trip.save
      puts "trip save successful #{@trip.id}"
      redirect_to passenger_path(passenger_id)
      return
    else
      puts "trip save unsuccessful #{@trip.id}"
      redirect_to new_passenger_trip_path(passenger_id)
      return
    end
  end

  def edit
    @trip = Trip.find_by(id: params[:id])
  end

  def update
    @trip = Trip.find_by(id: params[:id])


    if @trip.nil?
      redirect_to root_path
      return
    else
      @trip.update(rating: params[:trip][:rating] )
      redirect_to trip_path(@trip.id)
      return
    end
  end

  private
  def trip_params
    return params.require(:trip).permit(:date, :cost, :rating, :driver_id, :passenger_id)
  end
end
