require './lib/pantry'
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

end
