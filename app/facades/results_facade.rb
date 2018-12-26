class ResultsFacade
  def initialize(lat, lng, destination, radius)
    @lat = lat
    @lng = lng
    @destination = destination
    @radius = radius
    @_locations
  end

  def locations
    @_locations ||= lot_builder
    @_locations.find_all do |lot|
      lot.distance <= radius_in_feet
    end
  end

  def lot_builder
    @_location = service.get_results(@lat, @lng).map do |lot|
      # How to build location objects without passing in so many
      # variables?
      lat =lot[:lat]
      lng = lot[:lng]
      name = lot[:location_name]
      address = lot[:address]
      price = lot[:price]
      distance = lot[:distance]
      Lot.new(lat,lng,name,address,price, distance)
    end
  end

  private

  def radius_in_feet
    @radius.to_f * 5280.0
  end

  def service
    ParkwhizResultsService.new
  end

end
