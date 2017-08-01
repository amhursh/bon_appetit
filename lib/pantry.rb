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

  def determine_amount(num)
    return num = (num / 100) if num > 100
    return num = (num * 1000).to_i if num < 1
    return num
  end

  def determine_units(num)
    return "Centi-Units" if num > 100
    return "Milli-Units" if num < 1
    return "Universal-Units"
  end

  def convert_units(recipe)
    converted = {}
    recipe.ingredients.map do |ingred, quantity|
      converted[ingred] = {
        :quantity => determine_amount(quantity),
        :units => determine_units(quantity)
      }
    end
    converted
  end

end
