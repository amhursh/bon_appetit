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

  def test_number_conversion
    pantry = Pantry.new
    amount = 300
    amount_two = 0.234
    amount_three = 49

    assert_equal 3, pantry.determine_amount(amount)
    assert_equal 234, pantry.determine_amount(amount_two)
    assert_equal 49, pantry.determine_amount(amount_three)
  end

  def test_unit_name_conversion
    pantry = Pantry.new
    amount = 300
    amount_two = 0.234
    amount_three = 49

    assert_equal "Centi-Units", pantry.determine_units(amount)
    assert_equal "Milli-Units", pantry.determine_units(amount_two)
    assert_equal "Universal-Units", pantry.determine_units(amount_three)
  end

  def test_pantry_can_convert_units
    r = Recipe.new("Spicy Cheese Pizza")
    r.add_ingredient("Cayenne Pepper", 0.025)
    r.add_ingredient("Cheese", 75)
    r.add_ingredient("Flour", 500)
    pantry = Pantry.new
    converted = pantry.convert_units(r)
    expected = {"Cayenne Pepper"=>{:quantity=>25, :units=>"Milli-Units"},
                "Cheese"=>{:quantity=>75, :units=>"Universal-Units"},
                "Flour"=>{:quantity=>5, :units=>"Centi-Units"}}

    assert_instance_of Hash, converted
    assert_equal expected, converted
  end

  def test_pantry_can_add_recipes_to_cookbook
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)
    pantry = Pantry.new
    pantry.add_to_cookbook(r1)

    assert_instance_of Recipe, pantry.cookbook[0]
    assert_equal 1, pantry.cookbook.count
  end

  def test_pantry_can_add_more_recipes
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)
    r2 = Recipe.new("Brine Shot")
    r2.add_ingredient("Brine", 10)
    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)
    pantry = Pantry.new
    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)

    assert_instance_of Array, pantry.cookbook
    assert_instance_of Recipe, pantry.cookbook[2]
    assert_equal 3, pantry.cookbook.count
  end

  def test_necessary_ingredient_check_returns_true_when_ingredients_exist
    pantry = Pantry.new
    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)

    assert pantry.necessary_ingredients?(r1)
  end

  def test_necessary_ingredient_check_returns_false_when_one_or_more_dont_exist
    pantry = Pantry.new
    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)
    r1 = Recipe.new("Alien Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Space Flour", 20)
    r2 = Recipe.new("Street Pizza")
    r2.add_ingredient("Ciggie butts", 20)
    r2.add_ingredient("Needles", 20)

    refute pantry.necessary_ingredients?(r1)
    refute pantry.necessary_ingredients?(r2)
  end

  def tet_enough_stock_check_returns_true_when_there_is_enough_of_all_ingredients
    pantry = Pantry.new
    pantry.restock("Cheese", 30)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)
    r2 = Recipe.new("Brine Shot")
    r2.add_ingredient("Brine", 10)

    assert pantry.enough_stock?(r1)
    assert pantry.enough_stock?(r2)
  end

  def test_enough_stock_returns_false_if_not_enough_of_an_ingredient
    pantry = Pantry.new
    pantry.restock("Cheese", 30)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 50)
    r1.add_ingredient("Flour", 10)
    r2 = Recipe.new("Brine Shot")
    r2.add_ingredient("Brine", 99)

    refute pantry.enough_stock?(r1)
    refute pantry.enough_stock?(r2)
  end

  def test_pantry_can_check_what_can_be_made
    r1 = Recipe.new("Cheese Pizza")
    r1.add_ingredient("Cheese", 20)
    r1.add_ingredient("Flour", 20)
    r2 = Recipe.new("Brine Shot")
    r2.add_ingredient("Brine", 10)
    r3 = Recipe.new("Peanuts")
    r3.add_ingredient("Raw nuts", 10)
    r3.add_ingredient("Salt", 10)
    pantry = Pantry.new
    pantry.add_to_cookbook(r1)
    pantry.add_to_cookbook(r2)
    pantry.add_to_cookbook(r3)
    pantry.restock("Cheese", 10)
    pantry.restock("Flour", 20)
    pantry.restock("Brine", 40)
    pantry.restock("Raw nuts", 20)
    pantry.restock("Salt", 20)

    assert_equal ["Brine Shot", "Peanuts"], pantry.what_can_i_make
  end

end
