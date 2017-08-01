require './lib/pantry'
require './lib/recipe'
require 'minitest/autorun'
require 'minitest/pride'

class PantryTest < Minitest::Test

  def test_that_pantry_exists
    pantry = Pantry.new

    assert_instance_of Pantry, pantry
  end

  def test_pantry_has_empty_stock_by_default
    pantry = Pantry.new

    assert_equal ({}), pantry.stock
  end

  def test_pantry_can_test_stock
    pantry = Pantry.new

    assert_equal 0, pantry.stock_check("Cheese")
  end

  def test_pantry_can_restock_food
    pantry = Pantry.new
    pantry.restock("Cheese", 10)

    assert_equal 10, pantry.stock_check("Cheese")
  end

  def test_pantry_can_restock_even_more_food
    pantry = Pantry.new
    pantry.restock("Cheese", 10)

    assert_equal 10, pantry.stock_check("Cheese")

    pantry.restock("Cheese", 5)

    assert_equal 15, pantry.stock_check("Cheese")
  end

  def test_unit_conversion
    pantry = Pantry.new
    amount = 120
    amount_two = 0.234
    amount_three = 49

    assert_equal 1.2, pantry.determine_amount(amount)
    assert_equal 234, pantry.determine_amount(amount_two)
    assert_equal 49, pantry.determine_amount(amount_three)
  end

  def test_pantry_can_convert_units
    skip
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Cayenne Pepper", 0.025)
    r.add_ingredient("Cheese", 75)
    r.add_ingredient("Flour", 500)
    pantry = Pantry.new
    converted = pantry.convert_units(r)

    assert_instance_of Hash, converted
    assert_equal ({"Cayenne Pepper" => {quantity: 25, units: "Milli-Units"},
                  "Cheese" => {quantity: 75, units: "Universal Units"},
                  "Flour" => {quantity: 5, units: "Centi-Units"}}), converted
  end

end
