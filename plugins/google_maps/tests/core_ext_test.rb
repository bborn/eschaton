require File.dirname(__FILE__) + '/../../../test/test_helper'

class GoogleCoreExtTest < Test::Unit::TestCase
  
  def test_to_map_type
    assert_equal :G_NORMAL_MAP, :normal.to_map_type
    assert_equal :G_SATELLITE_MAP, :satellite.to_map_type
    assert_equal :G_HYBRID_MAP, :hybrid.to_map_type  
  end
  
  def test_to_google_control
    assert_equal :GSmallMapControl, :small_map.to_google_control
    assert_equal :GScaleControl, :scale.to_google_control
    assert_equal :GMapTypeControl, :map_type.to_google_control
    assert_equal :GOverviewMapControl, :overview_map.to_google_control  
  end
  
  def test_to_google_anchor
    assert_equal :G_ANCHOR_TOP_RIGHT, :top_right.to_google_anchor
    assert_equal :G_ANCHOR_TOP_LEFT, :top_left.to_google_anchor
    assert_equal :G_ANCHOR_BOTTOM_RIGHT, :bottom_right.to_google_anchor  
    assert_equal :G_ANCHOR_BOTTOM_LEFT, :bottom_left.to_google_anchor
  end

end
