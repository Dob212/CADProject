class BasicOrder
	def initialize(name, description, time, cost)
    	@oname = name
    	@odescription = description
    	@otime = time
    	@ocost = cost
	end

	def ocost
    	return @ocost
  	end

  	def details
    	return @odescription
  	end
end

class OrderDecorator
  def initialize(base_order)
    @base_order = base_order
    @extra_cost = 0
    @extra = "No extras"
  end

  def ocost
    return @extra_cost + @base_order.ocost
  end

  def details
    return @extra + ": #{@extra_cost} + " + @base_order.details
  end
end

class FoodDecorator < OrderDecorator
  def initialize(base_order)
    super(base_order)
      @description = "food supplied"
      @extra_cost = 25
  end

  def details
    return @description + ": #{@extra_cost} + " + @base_order.details		
  end
end

#travel decorator
class TravelDecorator < OrderDecorator
  def initialize(base_order)
    super(base_order)
    @description = "travel supplied"
    @extra_cost = 30
  end

  def details
    return @description + ": #{@extra_cost} + " +@base_order.details
  end
end