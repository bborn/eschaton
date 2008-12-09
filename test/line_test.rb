require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class LineTest < Test::Unit::TestCase

  def test_with_vertex
    Eschaton.with_global_script do |script|
      assert_output_fixture "line = new GPolyline([new GLatLng(-33.947, 18.462)], null, null, null);",
                            script.record_for_test {
                              Google::Line.new :vertices => {:latitude => -33.947, :longitude => 18.462}
                            }
    end    
  end

  def test_with_vertices
    Eschaton.with_global_script do |script|                      
      assert_output_fixture "line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], null, null, null);",
                            script.record_for_test {
                              Google::Line.new :vertices => [{:latitude => -33.947, :longitude => 18.462},
                                                             {:latitude => -34.0, :longitude => 19.0}]
                            }
   end    
  end

  def test_with_from_and_to
    Eschaton.with_global_script do |script|
      assert_output_fixture "line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], null, null, null);", 
                            script.record_for_test {
                               Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                                                :to =>  {:latitude => -34.0, :longitude => 19.0}
                            }
    end
  end

  def test_with_colour
    Eschaton.with_global_script do |script|
      assert_output_fixture 'line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], "red", null, null);',
                            script.record_for_test {
                              Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                                               :to =>  {:latitude => -34.0, :longitude => 19.0},
                                               :colour => 'red'
                            }
    end
  end

  def test_with_colour_and_weight
    Eschaton.with_global_script do |script|    
    assert_output_fixture 'line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], "red", 10, null);',
                          script.record_for_test {
                            Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                                             :to =>  {:latitude => -34.0, :longitude => 19.0},
                                             :colour => 'red', :thickness => 10
                          }
    end
  end

  def test_with_style
    Eschaton.with_global_script do |script|
      assert_output_fixture 'line = new GPolyline([new GLatLng(-33.947, 18.462), new GLatLng(-34.0, 19.0)], "red", 10, 0.7);',
                            script.record_for_test {
                              Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                                               :to =>  {:latitude => -34.0, :longitude => 19.0},
                                               :colour => 'red', :thickness => 10, :opacity => 0.7
                            }
    end
  end

  def test_between_markers
    Eschaton.with_global_script do |script|
      markers = [Google::Marker.new(:var => :marker_1, :location => {:latitude => -33.947, :longitude => 18.462}),
                 Google::Marker.new(:var => :marker_2, :location => {:latitude => -34.0, :longitude => 19.0}),
                 Google::Marker.new(:var => :marker_3, :location => {:latitude => -35.0, :longitude => 19.0})]

      assert_output_fixture 'line = new GPolyline([marker_1.getLatLng(), marker_2.getLatLng(), marker_3.getLatLng()], null, null, null);',
                            script.record_for_test {
                               Google::Line.new :between_markers => markers
                            }

      assert_output_fixture 'line = new GPolyline([marker_1.getLatLng(), marker_2.getLatLng(), marker_3.getLatLng()], "red", 10, null);',
                            script.record_for_test {
                               Google::Line.new :between_markers => markers,
                                                :colour => 'red', :thickness => 10
                            }                            
    end
  end
  
  def test_add_vertex
    Eschaton.with_global_script do |script|
      line = Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                              :to =>  {:latitude => -34.0, :longitude => 19.0}

      assert_output_fixture 'line.insertVertex(line.getVertexCount() - 1, new GLatLng(-34.5, 19.5))',
                            script.record_for_test {
                              line.add_vertex :latitude => -34.5, :longitude => 19.5
                            }
    end    
  end
  
  def test_length
    Eschaton.with_global_script do |script|
      line = Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                              :to =>  {:latitude => -34.0, :longitude => 19.0}

      assert_equal 'line.getLength()', line.length
      assert_equal 'line.getLength() / 1000', line.length(:kilometers)      
    end    
  end

  def test_style
    Eschaton.with_global_script do |script|
      line = Google::Line.new :from => {:latitude => -33.947, :longitude => 18.462},
                              :to =>  {:latitude => -34.0, :longitude => 19.0}

      assert_output_fixture 'line.setStrokeStyle({color: "red"});',
                            script.record_for_test {
                              line.style = {:colour => 'red'}
                            }

      assert_output_fixture 'line.setStrokeStyle({color: "red", weight: 12});',
                            script.record_for_test {
                              line.style = {:colour => 'red', :thickness => 12}
                            }
                       
      assert_output_fixture 'line.setStrokeStyle({color: "red", opacity: 0.7, weight: 12});',
                            script.record_for_test {
                              line.style = {:colour => 'red', :thickness => 12, :opacity => 0.7}
                            }
    end
  end

  def test_encoded
    Eschaton.with_global_script do |script|
      assert_output_fixture 'line = new GPolyline.fromEncoded({color: null, levels: "PFHFGP", numLevels: 18, opacity: null, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: null, zoomFactor: 2});',
                            script.record_for_test {
                              Google::Line.new(:encoded => {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP',
                                                            :num_levels => 18, :zoom_factor => 2})
                            }

      assert_output_fixture 'line = new GPolyline.fromEncoded({color: "green", levels: "PFHFGP", numLevels: 18, opacity: 1, points: "ihglFxjiuMkAeSzMkHbJxMqFfQaOoB", weight: 10, zoomFactor: 2});',
                            script.record_for_test {
                              Google::Line.new(:encoded => {:points => 'ihglFxjiuMkAeSzMkHbJxMqFfQaOoB', :levels => 'PFHFGP',
                                                            :num_levels => 18, :zoom_factor => 2},
                                               :colour => 'green', :opacity => 1, :thickness => 10)
                            }
    end
  end
    
end