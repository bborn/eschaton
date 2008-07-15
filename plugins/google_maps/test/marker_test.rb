require File.dirname(__FILE__) + '/../../../test/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class MarkerTest < Test::Unit::TestCase

  def test_marker_initialize
    Eschaton.with_global_script do |script|
      test_output = script.start_recording do
                      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
                    end

      assert_equal 'marker = new GMarker(new GLatLng(-33.947, 18.462), {});', 
                    test_output.generate

      test_output = script.start_recording do
                      marker = Google::Marker.new :location => :existing_location  
                    end

      assert_equal 'marker = new GMarker(existing_location, {});', test_output.generate

      test_output = script.start_recording do
                      marker = Google::Marker.new :location => :existing_location, :icon => :blue
                    end

      assert_output_fixture :marker_with_icon, test_output

      test_output = script.start_recording do
                      marker = Google::Marker.new :location => :existing_location, :title => 'Marker title!'
                    end

      assert_equal 'marker = new GMarker(existing_location, {title: "Marker title!"});',
                   test_output.generate

      test_output = script.start_recording do
                     marker = Google::Marker.new :location => :existing_location, :title => 'Marker title!', :draggable => true
                   end

      assert_equal 'marker = new GMarker(existing_location, {draggable: true, title: "Marker title!"});',
                    test_output.generate
    end
  end

  def test_marker_open_info_window
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}

      test_output = script.start_recording do
                      marker.open_info_window :url => {:controller => :location, :action => :show, :id => 1}
                    end

      assert_output_fixture :marker_open_info_window_with_url, test_output

      test_output = script.start_recording do
                      marker.open_info_window :partial => 'create'
                    end

      assert_equal 'marker.openInfoWindow("test output for render");', test_output.generate                          

      test_output = script.start_recording do
                      marker.open_info_window :text => "Testing text!"
                    end

      assert_equal 'marker.openInfoWindow("Testing text!");', test_output.generate      
    end
  end

  def test_click_output
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}

      # without body
      test_output = script.start_recording do
                      marker.click {}
                    end

      assert_output_fixture :marker_click_no_body, test_output
    
      # With body
      test_output = script.start_recording do
                      marker.click do |script|
                        script.comment "This is some test code!"
                        script.alert("Hello from marker click!")
                      end
                    end

      assert_output_fixture :marker_click_with_body, test_output

      # Info window convention
      test_output = script.start_recording do
                      marker.click :text => "This is a info window!"
                    end

      assert_output_fixture :marker_click_info_window, test_output
    end    
  end

  def test_show_map_blowup_output
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      # Default with hash location
      test_output = script.start_recording do
                      marker.show_map_blowup
                    end

      assert_equal 'marker.showMapBlowup({});', 
                   test_output.generate
      
      # With :zoom_level
      test_output = script.start_recording do
                      marker.show_map_blowup :zoom_level => 12
                    end

      assert_equal 'marker.showMapBlowup({zoomLevel: 12});', 
                   test_output.generate

      # With :marker_type
      test_output = script.start_recording do
                      marker.show_map_blowup :map_type => :satellite
                    end

      assert_equal 'marker.showMapBlowup({mapType: G_SATELLITE_MAP});', 
                   test_output.generate

      # With :zoom_level and :marker_type
      test_output = script.start_recording do
                      marker.show_map_blowup :zoom_level => 12, :map_type => :satellite
                    end

      assert_equal 'marker.showMapBlowup({mapType: G_SATELLITE_MAP, zoomLevel: 12});', 
                   test_output.generate
    end
  end
  
  def test_change_icon
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      test_output = script.start_recording do
                      marker.change_icon :green
                    end

      assert_equal 'marker.setImage("/images/green.png");', test_output.generate

      test_output = script.start_recording do
                      marker.change_icon "/images/blue.png"
                    end

      assert_equal 'marker.setImage("/images/blue.png");', test_output.generate      
    end
  end
  
  def test_to_marker
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      assert_equal marker, marker.to_marker
    end
  end
  
  def test_when_dropped
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      test_output = script.start_recording do 
        marker.when_dropped do |script, drop_location|
          assert script.generator?
          assert_equal :drop_location, drop_location
          
          script.comment "This is some test code!"
          script.alert("Hello from marker drop!")
        end
      end

      assert_output_fixture :marker_when_dropped, test_output
    end
  end
  
  def test_when_picked_up
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      test_output = script.start_recording do 
        marker.when_picked_up do |script|
          assert script.generator?
          
          script.comment "This is some test code!"
          script.alert("Hello from marker drop!")
        end
      end

      assert_output_fixture :marker_when_picked_up, test_output
    end
  end
  
end