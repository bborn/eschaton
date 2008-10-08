require File.dirname(__FILE__) + '/test_helper'

class GoogleCoreExtTest < Test::Unit::TestCase

  def setup
    JavascriptObject.global_script = Eschaton.javascript_generator
  end

  def teardown
    JavascriptObject.global_script = nil
  end
  
  def test_to_google_position
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(0, 0))',
                 ({:anchor => :top_left}).to_google_position
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 50))',
                 ({:anchor => :top_left, :offset => [10, 50]}).to_google_position
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 10))',
                 ({:anchor => :top_right, :offset => [10, 10]}).to_google_position
  end
  
  def test_array_to_google_size
    assert_equal "new GSize(10, 10)", [10, 10].to_google_size
    assert_equal "new GSize(100, 50)", [100, 50].to_google_size
    assert_equal "new GSize(200, 150)", [200, 150].to_google_size    
  end
  
  def test_to_image
    assert_equal "/images/green.png", :green.to_image
    assert_equal "/images/green.png", "/images/green.png".to_image
  end
  
  def test_options_helper_to_icon
    assert_equal Google::Icon, Google::OptionsHelper.to_icon("green").class
    assert_equal Google::Icon, Google::OptionsHelper.to_icon(:green).class
    assert_equal Google::Icon, Google::OptionsHelper.to_icon({:image => :green}).class
  end

  def test_to_gravatar_icon
    assert_equal Google::GravatarIcon, ({:email_address => 'joesoap@email.com'}).to_gravatar_icon.class
    assert_equal Google::GravatarIcon, 'joesoap@email.com'.to_gravatar_icon.class    
  end

  def test_options_helper_to_location
    assert_equal "location", Google::OptionsHelper.to_location("location")
    assert_equal "map.getCenter()", Google::OptionsHelper.to_location("map.getCenter()")
    assert_equal :location, Google::OptionsHelper.to_location(:location)
    assert_equal :marker_location, Google::OptionsHelper.to_location(:marker_location)

    location_hash = {:latitide => 34, :longitude => 18}
    location = Google::OptionsHelper.to_location(location_hash)

    assert_equal Google::Location, location.class
    assert_equal location_hash[:latitude], location.latitude
    assert_equal location_hash[:longitude], location.longitude

    location_array = [18, 34]
    location = Google::OptionsHelper.to_location(location_array)

    assert_equal Google::Location, location.class
    assert_equal location_array.first, location.latitude
    assert_equal location_array.second, location.longitude
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
  end
  
  def test_to_marker
    assert_equal Google::Marker, {:location => :existing}.to_marker.class
  end

  def test_to_line
    assert_equal Google::Line, {:vertices => :first_location}.to_line.class
  end

end
