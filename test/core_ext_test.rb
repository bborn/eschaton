require File.dirname(__FILE__) + '/test_helper'

class GoogleCoreExtTest < Test::Unit::TestCase

  def setup
    JavascriptObject.global_script = Eschaton.javascript_generator
  end

  def teardown
    JavascriptObject.global_script = nil
  end
  
  def test_array_to_google_size
    assert_equal "new GSize(10, 10)", [10, 10].to_google_size
    assert_equal "new GSize(100, 50)", [100, 50].to_google_size
    assert_equal "new GSize(200, 150)", [200, 150].to_google_size    
  end

  def test_to_google_control
    assert_equal :GSmallMapControl, :small_map.to_google_control
    assert_equal :GScaleControl, :scale.to_google_control
    assert_equal :GMapTypeControl, :map_type.to_google_control
    assert_equal :GOverviewMapControl, :overview_map.to_google_control  
  end
  
  def test_to_map_type
    assert_equal :G_NORMAL_MAP, :normal.to_map_type
    assert_equal :G_SATELLITE_MAP, :satellite.to_map_type
    assert_equal :G_HYBRID_MAP, :hybrid.to_map_type  
  end
  
  def test_to_google_anchor
    assert_equal :G_ANCHOR_TOP_RIGHT, :top_right.to_google_anchor
    assert_equal :G_ANCHOR_TOP_LEFT, :top_left.to_google_anchor
    assert_equal :G_ANCHOR_BOTTOM_RIGHT, :bottom_right.to_google_anchor  
    assert_equal :G_ANCHOR_BOTTOM_LEFT, :bottom_left.to_google_anchor
  end

  def test_to_google_options
   assert_equal '{bounceGravity: 12, draggable: true, title: "My title!"}',
                 {:draggable => true, :bounce_gravity => 12, :title => "My title!"}.to_google_options

   assert_equal '{dragCrossMove: true, icon: local_icon}', 
                 {:drag_cross_move => true, :icon => :local_icon}.to_google_options

   assert_equal '{color: "red", opacity: 0.7, weight: 10}', 
                 {:color => 'red', :weight => 10, :opacity => 0.7}.to_google_options

   assert_equal '{color: "blue", offset: new GSize(10, 10)}',
                 {:color => 'blue', :offset => [10, 10].to_google_size}.to_google_options(:dont_convert => [:offset])

   assert_equal '{color: "blue", zone: zz1}',
                 {:color => 'blue', :zone => 'zz1'}.to_google_options(:dont_convert => [:zone])
  end
  
end
