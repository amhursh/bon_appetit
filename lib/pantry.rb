class Pantry

  attr_reader :stock

  def initialize
    @stock = {}
  end

  def stock_check(food)
    return 0 if stock[food].nil?
    stock[food]
  end

end
