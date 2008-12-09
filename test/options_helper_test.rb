require File.dirname(__FILE__) + '/test_helper'

class OptionsHelperTest < Test::Unit::TestCase

  def setup
    JavascriptObject.global_script = Eschaton.javascript_generator
  end

  def teardown
    JavascriptObject.global_script = nil
  end
  
  def test_to_google_position
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(0, 0))',
                 Google::OptionsHelper.to_google_position({:anchor => :top_left})
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_LEFT, new GSize(10, 50))',
                 Google::OptionsHelper.to_google_position({:anchor => :top_left, :offset => [10, 50]})
    assert_equal 'new GControlPosition(G_ANCHOR_TOP_RIGHT, new GSize(10, 10))',
                 Google::OptionsHelper.to_google_position({:anchor => :top_right, :offset => [10, 10]})
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

  def test_to_encoded_polyline
    line = {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP', :color => 'red',
            :opacity => 0.7, :weight => 3, :num_levels => 18, :zoom_factor => 2}

    assert_equal '{color: "red", levels: "PFHFGP", numLevels: 18, opacity: 0.7, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: 3, zoomFactor: 2}',
                  Google::OptionsHelper.to_encoded_polyline(line)
                  
    line = {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP'}

    assert_equal '{levels: "PFHFGP", points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB"}',
                  Google::OptionsHelper.to_encoded_polyline(line)                  
  end
  
  def test_to_encoded_polylines
    options = {:color => 'red', :opacity => 0.7, :weight => 3}
    options[:lines] = [{:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP', :num_levels => 18, :zoom_factor => 2},
                       {:points => 'cbglFhciuMY{FtDqBfCvD{AbFgEm@', :levels => 'PDFDEP', :num_levels => 18, :zoom_factor => 2}]

    assert_equal '[{color: "red", levels: "PFHFGP", numLevels: 18, opacity: 0.7, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: 3, zoomFactor: 2}, {levels: "PDFDEP", numLevels: 18, points: "cbglFhciuMY{FtDqBfCvD{AbFgEm@", zoomFactor: 2}]',
                  Google::OptionsHelper.to_encoded_polylines(options)
  end

end
