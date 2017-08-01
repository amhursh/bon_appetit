require 'pry'

class Pantry

  attr_reader :stock,
              :cookbook

  def initialize
    @stock = {}
    @cookbook = []
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

  def add_to_cookbook(recipe)
    cookbook << recipe
  end

  def necessary_ingredients?(recipe)
    recipe.ingredients.keys.all? do |ingredient|
      stock.keys.include?(ingredient)
    end
  end

  def enough_stock?(recipe)
    recipe.ingredients.all? do |ingredient, amount|
      stock[ingredient] >= amount
    end
  end

  def what_can_i_make
    cookbook.select do |recipe|
      necessary_ingredients?(recipe) && enough_stock?(recipe)
    end.map {|recipe| recipe.name}
  end

  def available_recipes
    cookbook.select do |recipe|
      necessary_ingredients?(recipe) && enough_stock?(recipe)
    end
  end

  def how_many_can_i_make
    output = {}
    available_recipes.each do |recipe|
      recipe.ingredients.each do |ingredient, amount|
        output[recipe.name] = stock[ingredient] / amount
      end
    end
    output
  end

end
