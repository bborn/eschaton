require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class MarkerTest < Test::Unit::TestCase

  def test_initialize
    Eschaton.with_global_script do |script|
      assert_output_fixture 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});', 
                             script.record_for_test {
                                marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
                              }

      assert_output_fixture 'marker = new GMarker(existing_location, {draggable: false});', 
                             script.record_for_test {
                               marker = Google::Marker.new :location => :existing_location  
                             }

      assert_output_fixture :marker_with_icon,
                            script.record_for_test {
                              marker = Google::Marker.new :location => :existing_location, :icon => :blue
                            }

      assert_output_fixture 'marker = new GMarker(existing_location, {draggable: false, title: "Marker title!"});',
                            script.record_for_test {
                              marker = Google::Marker.new :location => :existing_location, :title => 'Marker title!'
                            }

      assert_output_fixture 'marker = new GMarker(existing_location, {bouncy: false, draggable: false, title: "Marker title!"});',
                            script.record_for_test {
                              marker = Google::Marker.new :location => :existing_location, :title => 'Marker title!',
                                                          :bouncy => false
                            }                            
                            
    end
  end

  def test_initialize_with_gravatar
    Eschaton.with_global_script do |script|
      assert_output_fixture :marker_gravatar, 
                             script.record_for_test {
                               Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                  :gravatar => 'yawningman@eschaton.com'
                             }

     assert_output_fixture :marker_gravatar, 
                            script.record_for_test {
                              Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :gravatar => {:email_address => 'yawningman@eschaton.com'}
                            }

      assert_output_fixture :marker_gravatar_with_size, 
                            script.record_for_test {
                              Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :gravatar => {:email_address => 'yawningman@eschaton.com', :size => 50}
                            }

      assert_output_fixture :marker_gravatar_with_default_icon, 
                            script.record_for_test {
                              Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :gravatar => {:email_address => 'yawningman@eschaton.com', 
                                                               :default => 'http://localhost:3000/images/blue.png'}
                            }

      assert_output_fixture :marker_gravatar_with_size_and_default_icon, 
                            script.record_for_test {
                              Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                  :gravatar => {:email_address => 'yawningman@eschaton.com', 
                                                                :default => 'http://localhost:3000/images/blue.png',
                                                                :size => 50}
                            }
    end 
  end

  def test_initialize_with_tooltip
    Eschaton.with_global_script do |script|
      assert_output_fixture :marker_tooltip, 
                             script.record_for_test {
                               Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                  :tooltip => {:text => 'This is sparta!'}
                             }
                             
      assert_output_fixture :marker_tooltip,
                            script.record_for_test {
                              Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :tooltip => {:text => 'This is sparta!', :show => :on_mouse_hover}
                            }

      assert_output_fixture :marker_tooltip_show_always, 
                            script.record_for_test {
                              Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :tooltip => {:text => 'This is sparta!', :show => :always}
                            }
 
      assert_output_fixture :marker_tooltip_with_partial,
                            script.record_for_test {
                              Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :tooltip => {:partial => 'spot_information'}
                            }
   end
  end

  def test_location
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      assert_equal "marker.getLatLng()", marker.location
      
      marker_one = Google::Marker.new :var => :marker_one, :location => {:latitude => -33.947, :longitude => 18.462}
      assert_equal "marker_one.getLatLng()", marker_one.location
      
      marker = Google::Marker.new :location => :mouse_location
      assert_equal "marker.getLatLng()", marker.location      
   end    
  end


  def test_marker_open_info_window
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}

      assert_output_fixture :marker_open_info_window_with_url,
                            script.record_for_test {
                              marker.open_info_window :url => {:controller => :location, :action => :show, :id => 1}
                            }

      assert_output_fixture 'marker.openInfoWindow("<div id=\'info_window_content\'>" + "test output for render" + "</div>");', 
                             script.record_for_test {
                               marker.open_info_window :partial => 'create'
                             }

      assert_output_fixture 'marker.openInfoWindow("<div id=\'info_window_content\'>" + "Testing text!" + "</div>");', 
                             script.record_for_test {
                               marker.open_info_window :text => "Testing text!"
                             }
    end
  end

  def test_click
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

  def test_when_picked_up
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture :marker_when_picked_up,
                            script.record_for_test{ 
                              marker.when_picked_up{|script|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker drop!")
                              }
                            }
    end
  end

  def test_when_being_dragged
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture :marker_when_being_dragged,
                            script.record_for_test{
                              marker.when_being_dragged{|script, current_location|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker drag!")
                              }
                            }
    end
  end
  
  def test_when_dropped
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      test_output = script.record_for_test do 
        marker.when_dropped do |script, drop_location|
          assert_equal :drop_location, drop_location
          
          script.comment "This is some test code!"
          script.alert("Hello from marker drop!")
        end
      end

      assert_output_fixture :marker_when_dropped, test_output
    end
  end
  
  def test_show_map_blowup
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
  
  def test_circle
    Eschaton.with_global_script do |script|
      assert_output_fixture 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                             circle_marker = drawCircle(marker.getLatLng(), 1.5, 40, null, 2, null, "#0055ff", null);', 
                             script.record_for_test{
                               Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                  :circle => true
                             }
 
      assert_output_fixture 'marker = new GMarker(new GLatLng(-33.947, 18.462), {draggable: false});
                             circle_marker = drawCircle(marker.getLatLng(), 500, 40, null, 5, null, "#0055ff", null);', 
                            script.record_for_test{
                              Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                                 :circle => {:radius => 500, :border_width => 5}
                            }

     marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}

     assert_output_fixture 'circle_marker = drawCircle(marker.getLatLng(), 1.5, 40, null, 2, null, "#0055ff", null);', 
                            script.record_for_test{
                              marker.circle!  
                            }

     assert_output_fixture 'circle_marker = drawCircle(marker.getLatLng(), 500, 40, null, 5, null, "#0055ff", null);', 
                           script.record_for_test{
                             marker.circle! :radius => 500, :border_width => 5
                           }

     assert_output_fixture 'circle_marker = drawCircle(marker.getLatLng(), 500, 40, null, 5, null, "black", null);', 
                           script.record_for_test{
                             marker.circle! :radius => 500, :border_width => 5, :fill_colour => 'black'
                           }
    end    
  end
  
  def test_set_tooltip
    Eschaton.with_global_script do |script|            
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      assert_false marker.has_tooltip?
      
      assert_output_fixture :marker_set_tooltip_default, 
                             script.record_for_test{
                               marker.set_tooltip :text => 'This is sparta!'
                             }

      assert_output_fixture :marker_set_tooltip_default, 
                            script.record_for_test{
                              marker.set_tooltip :text => 'This is sparta!', :show => :on_mouse_hover
                            }
                            
      assert_output_fixture :marker_set_tooltip_show_always, 
                            script.record_for_test{
                              marker.set_tooltip :text => 'This is sparta!', :show => :always
                            }

      assert_output_fixture :marker_set_tooltip_show_false, 
                            script.record_for_test{
                              marker.set_tooltip :text => 'This is sparta!', :show => false
                            }
      
      assert_output_fixture :marker_set_tooltip_default_with_partial, 
                            script.record_for_test{
                              marker.set_tooltip :partial => 'spot_information'
                            }

     assert_output_fixture :marker_set_tooltip_default_with_partial, 
                           script.record_for_test{
                             marker.set_tooltip :partial => 'spot_information', :show => :on_mouse_hover
                           }
                           
      assert marker.has_tooltip?                                          
    end
  end

  def test_update_tooltip
    Eschaton.with_global_script do |script|            
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}

      assert_false marker.has_tooltip?
      
      # If you update and there is no tooltip it will use the default behavior
      assert_output_fixture :marker_set_tooltip_default,
                            script.record_for_test{
                              marker.update_tooltip :text => 'This is sparta!'
                            }

      assert_output_fixture 'tooltip_marker.updateHtml("This is sparta!");',
                            script.record_for_test{
                              marker.update_tooltip :text => 'This is sparta!'
                            }

      assert_output_fixture 'tooltip_marker.updateHtml("test output for render");',
                             script.record_for_test{
                               marker.update_tooltip :partial => 'This is sparta!'
                             }

      assert marker.has_tooltip?
    end
  end

  def test_show_tooltip
    Eschaton.with_global_script do |script|            
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                  :tooltip => {:text => 'This is sparta!'}

      assert_output_fixture 'tooltip_marker.show();', 
                             script.record_for_test{
                               marker.show_tooltip!
                             }
    end    
  end

  def test_hide_tooltip
    Eschaton.with_global_script do |script|            
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462},
                                  :tooltip => {:text => 'This is sparta!'}

      assert_output_fixture 'tooltip_marker.hide();', 
                             script.record_for_test{
                               marker.hide_tooltip!
                             }
    end    
  end

  def test_draggable
    Eschaton.with_global_script do |script|
      assert_output_fixture 'marker = new GMarker(existing_location, {draggable: false});',
                            script.record_for_test {
                              marker = Google::Marker.new :location => :existing_location
                              assert_false marker.draggable?
                            }

      assert_output_fixture :marker_draggable,
                            script.record_for_test {
                              marker = Google::Marker.new :location => :existing_location, :title => 'Draggable marker!', 
                                                          :draggable => true
                              assert marker.draggable?
                            }
    end    
  end

  def test_mouse_over
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture :marker_mouse_over,
                            script.record_for_test{ 
                              marker.mouse_over{|script|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker drop!")
                              }
                            }
    end
  end

  def test_mouse_off
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      assert_output_fixture :marker_mouse_off,
                            script.record_for_test{ 
                              marker.mouse_off{|script|
                                script.comment "This is some test code!"
                                script.alert("Hello from marker drop!")
                              }
                            }
    end
  end

  def test_move_to
    Eschaton.with_global_script do |script|            
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      assert_output_fixture 'marker.setLatLng(new GLatLng(-33.947, 18.562));', 
                             script.record_for_test{
                               marker.move_to :latitude => -33.947, :longitude => 18.562
                             }
                             
      marker.set_tooltip :text => "This is sparta!"

      assert_output_fixture 'marker.setLatLng(new GLatLng(-33.947, 18.562));
                             tooltip_marker.redraw(true);', 
                            script.record_for_test{
                              marker.move_to :latitude => -33.947, :longitude => 18.562
                            }
       
      marker.circle! 
                            
      assert_output_fixture 'marker.setLatLng(new GLatLng(-33.947, 18.562));
                             tooltip_marker.redraw(true);
                             map.removeOverlay(circle_marker)
                             circle_marker = drawCircle(new GLatLng(-33.947, 18.562), 1.5, 40, null, 2, null, "#0055ff", null);', 
                            script.record_for_test{
                              marker.move_to :latitude => -33.947, :longitude => 18.562
                            }                            
    end    
  end

  def test_to_marker
    Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => {:latitude => -33.947, :longitude => 18.462}
      
      assert_equal marker, marker.to_marker
    end
  end  
  
end