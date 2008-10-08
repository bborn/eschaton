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
    assert_equal "/images/green.png",  Google::OptionsHelper.to_image(:green)
    assert_equal "/images/green.png", Google::OptionsHelper.to_image("/images/green.png")
  end
  
  def test_options_helper_to_icon
    assert_equal Google::Icon, Google::OptionsHelper.to_icon("green").class
    assert_equal Google::Icon, Google::OptionsHelper.to_icon(:green).class
    assert_equal Google::Icon, Google::OptionsHelper.to_icon({:image => :green}).class
  end

  def test_to_gravatar_icon
    assert_equal Google::GravatarIcon, Google::OptionsHelper.to_gravatar_icon(:email_address => 'joesoap@email.com').class    
    assert_equal Google::GravatarIcon, Google::OptionsHelper.to_gravatar_icon('joesoap@email.com').class    
  end

  def test_options_helper_to_location
    assert_equal "location", Google::OptionsHelper.to_location("location")
    assert_equal "map.getCenter()", Google::OptionsHelper.to_location("map.getCenter()")
    assert_equal :location, Google::OptionsHelper.to_location(:location)
    assert_equal :marker_location, Google::OptionsHelper.to_location(:marker_location)

    location = Google::Location.new(:latitide => 34, :longitude => 18)
    assert_equal location, Google::OptionsHelper.to_location(location)

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
    marker = Google::Marker.new(:location => {:latitude => -33.947, :longitude => 18.462})

    assert_equal marker, Google::OptionsHelper.to_marker(marker)
    assert_equal Google::Marker, Google::OptionsHelper.to_marker(:location => :existing).class    
  end

  def test_to_line
    line = Google::Line.new(:vertices => :first_location)

    assert_equal line, Google::OptionsHelper.to_line(line)
    assert_equal Google::Line, Google::OptionsHelper.to_line(:vertices => :first_location).class
  end

end
