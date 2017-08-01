class Pantry

  attr_reader :stock

  def initialize
    @stock = {}
  end

  def stock_check(food)
    return 0 if stock[food].nil?
    stock[food]
  end

  def restock(food, quantity)
     if stock[food].nil?
       stock[food] = quantity
    else
      stock[food] = stock[food] + quantity
    end
  end

end
