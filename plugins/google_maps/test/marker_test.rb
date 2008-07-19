require File.dirname(__FILE__) + '/../../../test/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class MarkerTest < Test::Unit::TestCase

  def test_marker_initialize
    Eschaton.with_global_script do |script|
      assert_output_fixture 'marker = new GMarker(new GLatLng(-33.947, 18.462), {});', 
                             script.record_for_test {
                                marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
                              }

      assert_output_fixture 'marker = new GMarker(existing_location, {});', 
                             script.record_for_test {
                               marker = Google::Marker.new :location => :existing_location  
                             }

      assert_output_fixture :marker_with_icon,
                            script.record_for_test {
                              marker = Google::Marker.new :location => :existing_location, :icon => :blue
                            }

      assert_output_fixture 'marker = new GMarker(existing_location, {title: "Marker title!"});',
                            script.record_for_test {
                              marker = Google::Marker.new :location => :existing_location, :title => 'Marker title!'
                            }

      assert_output_fixture 'marker = new GMarker(existing_location, {draggable: true, title: "Marker title!"});',
                            script.record_for_test {
                              marker = Google::Marker.new :location => :existing_location, :title => 'Marker title!', :draggable => true
                            }
    end
  end

  def test_marker_open_info_window
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}

      assert_output_fixture :marker_open_info_window_with_url,
                            script.record_for_test {
                              marker.open_info_window :url => {:controller => :location, :action => :show, :id => 1}
                            }

      assert_output_fixture 'marker.openInfoWindow("test output for render");', 
                             script.record_for_test {
                               marker.open_info_window :partial => 'create'
                             }

      assert_output_fixture 'marker.openInfoWindow("Testing text!");', 
                             script.record_for_test {
                               marker.open_info_window :text => "Testing text!"
                             }
    end
  end

  def test_click_output
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}

      # without body
      assert_output_fixture :marker_click_no_body, 
                            script.record_for_test {
                                            marker.click {}
                                          }
    
      # With body
      assert_output_fixture :marker_click_with_body,
                            script.record_for_test {
                              marker.click do |script|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker click!")
                              end
                            }

      # Info window convention
      assert_output_fixture :marker_click_info_window,
                            script.record_for_test {
                              marker.click :text => "This is a info window!"
                            }
    end    
  end

  def test_show_map_blowup_output
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      # Default with hash location
      assert_output_fixture 'marker.showMapBlowup({});', 
                            script.record_for_test {
                              marker.show_map_blowup
                            }
      
      # With :zoom_level
      assert_output_fixture 'marker.showMapBlowup({zoomLevel: 12});', 
                            script.record_for_test {
                              marker.show_map_blowup :zoom_level => 12
                            }

      # With :marker_type
      assert_output_fixture 'marker.showMapBlowup({mapType: G_SATELLITE_MAP});', 
                            script.record_for_test {
                              marker.show_map_blowup :map_type => :satellite
                            }

      # With :zoom_level and :marker_type
      assert_output_fixture 'marker.showMapBlowup({mapType: G_SATELLITE_MAP, zoomLevel: 12});', 
                            script.record_for_test {
                              marker.show_map_blowup :zoom_level => 12, :map_type => :satellite
                            }
    end
  end
  
  def test_change_icon
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture 'marker.setImage("/images/green.png");', 
                             script.record_for_test {
                               marker.change_icon :green
                             }

      assert_output_fixture 'marker.setImage("/images/blue.png");', 
                            script.record_for_test {
                              marker.change_icon "/images/blue.png"
                            }
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
      
      test_output = script.record_for_test do 
        marker.when_dropped do |script, drop_location|
          assert script.is_a?(ActionView::Helpers::PrototypeHelper::JavaScriptGenerator)
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
      
      test_output = script.record_for_test do 
        marker.when_picked_up do |script|
          assert script.is_a?(ActionView::Helpers::PrototypeHelper::JavaScriptGenerator)
          
          script.comment "This is some test code!"
          script.alert("Hello from marker drop!")
        end
      end

      assert_output_fixture :marker_when_picked_up, test_output
    end
  end
  
end