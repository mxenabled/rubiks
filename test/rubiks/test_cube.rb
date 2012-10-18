require 'test_helper'

class TestCube < MiniTest::Unit::TestCase
  def setup
    @subject = Rubiks::Cube.new
  end

  def test_for_dimensions
    assert_respond_to @subject, :dimensions
  end

  def test_for_measures
    assert_respond_to @subject, :measures
  end
end
