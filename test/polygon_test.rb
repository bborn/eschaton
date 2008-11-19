require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class PolygonTest < Test::Unit::TestCase

  def test_center
    Eschaton.with_global_script do |script|
      
      polygon = Google::Polygon.new :vertices => []
      assert_equal "polygon.getBounds().getCenter()", polygon.center

      my_polygon = Google::Polygon.new :var => :my_polygon, :vertices => []
      assert_equal "my_polygon.getBounds().getCenter()", my_polygon.center

    end
  end

end