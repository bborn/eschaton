require File.dirname(__FILE__) + '/../../../test/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class MapTest < Test::Unit::TestCase
  
  def test_map_initialize
    map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}, :script => Eschaton.javascript_generator

    assert_output_fixture :map_default, map.send(:script)

    map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462},
                          :controls => [:small_map, :map_type],
                          :zoom => 12,
                          :type => :satellite,
                          :script => Eschaton.javascript_generator
    
    assert_output_fixture :map_with_args, map.send(:script)
  end

  def test_open_info_window_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      # With :url and :include_location params
      test_output = script.start_recording do
                      map.open_info_window :url => {:controller => :location, :action => :create}
                    end

      assert_output_fixture :map_open_info_window_url_center, test_output

      test_output = script.start_recording do
                      map.open_info_window :location => :center, 
                                           :url => {:controller => :location, :action => :create}
                    end

      assert_output_fixture :map_open_info_window_url_center, test_output

      test_output = script.start_recording do
                      map.open_info_window :location => :existing_location, 
                                           :url => {:controller => :location, :action => :create}
                    end

      assert_output_fixture :map_open_info_window_url_existing_location, test_output

      test_output = script.start_recording do
                      map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                           :url => {:controller => :location, :action => :create}
                    end

      assert_output_fixture :map_open_info_window_url_location, test_output

      test_output = script.start_recording do
                      map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, 
                                           :url => {:controller => :location, :action => :show, :id => 1},
                                           :include_location => false
                    end

      assert_output_fixture :map_open_info_window_url_no_location, test_output

      test_output = script.start_recording do
                      map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, :partial => 'create'
                    end

      assert_equal 'map.openInfoWindow(new GLatLng(-33.947, 18.462), "test output for render");', test_output.generate                          

      test_output = script.start_recording do
                      map.open_info_window :location => {:latitude => -33.947, :longitude => 18.462}, :text => "Testing text!"
                    end

      assert_equal 'map.openInfoWindow(new GLatLng(-33.947, 18.462), "Testing text!");', test_output.generate
    end    
  end
  
  def test_click_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462} 

      # without body
      test_output = script.start_recording do
                      map.click {}
                    end

      assert_output_fixture :map_click_no_body, test_output
    
      # With body
      test_output = script.start_recording do
                      map.click do |script, location|
                        script.comment "This is some test code!"
                        script.comment "'#{location}' is where the map was clicked!"
                        script.alert("Hello from map click!")
                      end
                    end

      assert_output_fixture :map_click_with_body, test_output
    
      # Info window convention
      test_output = script.start_recording do
                      map.click :text => "This is a info window!"
                    end

      assert_output_fixture :map_click_info_window, test_output
    end    
  end
  
  def test_add_marker
    Eschaton.with_global_script do
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      first_marker_location = {:latitude => -33.947, :longitude => 18.462}
      marker = map.add_marker :location => first_marker_location
    
      assert marker.is_a?(Google::Marker)
      assert marker.location.is_a?(Google::Location)
      assert_equal first_marker_location[:latitude], marker.location.latitude
      assert_equal first_marker_location[:longitude], marker.location.longitude      
    end
    
    # Now add multiple markers
    Eschaton.with_global_script do
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      first_marker_location = {:latitude => -33.947, :longitude => 18.462}
      second_marker_location = {:latitude => -34.947, :longitude => 18.462}
      
      markers = map.add_markers({:location => first_marker_location}, {:location => second_marker_location})
      
      assert markers.is_a?(Array)
      assert_equal 2, markers.size
      
      first_marker = markers[0]
      
      assert first_marker.is_a?(Google::Marker)
      assert first_marker.location.is_a?(Google::Location)
      assert_equal first_marker_location[:latitude], first_marker.location.latitude
      assert_equal first_marker_location[:longitude], first_marker.location.longitude
      
      second_marker = markers[1]
      
      assert second_marker.is_a?(Google::Marker)
      assert second_marker.location.is_a?(Google::Location)
      assert_equal second_marker_location[:latitude], second_marker.location.latitude
      assert_equal second_marker_location[:longitude], second_marker.location.longitude
    end
    
  end
  
  def test_add_marker_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      test_output = script.start_recording do
                      map.add_marker :location => {:latitude => -33.947, :longitude => 18.462}
                    end

      assert_output_fixture :map_add_marker, test_output

      test_output = script.start_recording do
        map.add_markers({:location => {:latitude => -33.947, :longitude => 18.462}},
                        {:location => {:latitude => -34.947, :longitude => 19.462}})
      end
      
      assert_output_fixture :map_add_markers, test_output
    end
  end

  def test_add_line
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      line = map.add_line :vertices => {:latitude => -33.947, :longitude => 18.462}
      
      assert line.is_a?(Google::Line)
    end
  end

  def test_add_line_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      test_output = script.start_recording do 
                      map.add_line :vertices => {:latitude => -33.947, :longitude => 18.462}
                    end

      assert_output_fixture :map_add_line, test_output
    end
  end

  def test_clear_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      test_output = script.start_recording do 
                      map.clear
                    end
      
      assert_equal 'map.clearOverlays();', test_output.generate
    end
  end

  def test_show_map_blowup_output
    Eschaton.with_global_script do |script|
      map = Google::Map.new :center => {:latitude => -33.947, :longitude => 18.462}
      
      # Default with hash location
      test_output = script.start_recording do
                      map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462}
                    end
      
      assert_equal 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {});', 
                   test_output.generate
                   
     # Default with existing_location
     test_output = script.start_recording do
                     map.show_blowup :location => :existing_location
                   end

     assert_equal 'map.showMapBlowup(existing_location, {});', 
                  test_output.generate
      
      # With :zoom_level
      test_output = script.start_recording do
                      map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                      :zoom_level => 12
                    end

      assert_equal 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {zoomLevel: 12});', 
                   test_output.generate

      # With :map_type
      test_output = script.start_recording do
                      map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                      :map_type => :satellite
                    end

      assert_equal 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {mapType: G_SATELLITE_MAP});', 
                   test_output.generate

      # With :zoom_level and :map_type
      test_output = script.start_recording do
                      map.show_blowup :location => {:latitude => -33.947, :longitude => 18.462},
                                      :zoom_level => 12,
                                      :map_type => :satellite
                    end

      assert_equal 'map.showMapBlowup(new GLatLng(-33.947, 18.462), {zoomLevel: 12, mapType: G_SATELLITE_MAP});', 
                   test_output.generate
    end
  end

end
