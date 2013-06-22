require "minitest/autorun"
require "metric_adapter"

class LocationTest < MiniTest::Unit::TestCase
  include MetricAdapter
  
  def test_creating_a_location_with_line_number 
    path = "./test"
    line = 7
    location = Location.new(path, 7)
    
    assert_equal path, location.path
    assert_equal line, location.line
  end
  
  def test_creating_a_location_with_no_number
    path = "./test"
    location = Location.new(path)
    
    assert_equal path, location.path
    assert_equal 0, location.line
  end
  
  def test_creating_a_location_with_embedded_line_number
    path = "./test"
    line = 17
    location = Location.new("#{path}:#{line}")
    
    assert_equal path, location.path
    assert_equal line, location.line
  end
  
  def test_retains_colons
    path = "yes:we_have_no_banannas"
    line = 17
    location = Location.new("#{path}:#{line}")
    
    assert_equal path, location.path
    assert_equal line, location.line
  end
  
  def test_nil_path
    location = Location.new(nil)
    
    assert_equal "", location.path
    assert_equal 0,  location.line
  end
    
end