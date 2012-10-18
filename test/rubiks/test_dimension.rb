require 'test_helper'

class TestDimension < MiniTest::Unit::TestCase
  def setup
    @subject = Rubiks::Dimension.new
  end

  def test_for_heirarchies
    assert_respond_to @subject, :hierarchies
  end
end
