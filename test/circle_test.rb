require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class CircleTest < Test::Unit::TestCase

  def test_initialize
    Eschaton.with_global_script do |script|
      location = {:latitude => -35.0, :longitude => 18.0}

      assert_output_fixture 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1.5, 40, null, 2, null, "#0055ff", null);',
                             script.record_for_test {
                               Google::Circle.new :location => location
                             }

      assert_output_fixture 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, null, 2, null, "#0055ff", null);',
                            script.record_for_test {
                              Google::Circle.new :location => location, :radius => 1000
                            }

      assert_output_fixture 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 2, null, "#0055ff", null);',
                            script.record_for_test {
                              Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red'
                            }

      assert_output_fixture 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 5, null, "#0055ff", null);',
                           script.record_for_test {
                             Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
                                                :border_width => 5
                           }

      assert_output_fixture 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 5, 0.7, "#0055ff", null);',
                            script.record_for_test {
                              Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
                                                 :border_width => 5, :border_opacity => 0.7
                            }

      assert_output_fixture 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 5, 0.7, "black", null);',
                            script.record_for_test {
                              Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
                                                 :border_width => 5, :border_opacity => 0.7,
                                                 :fill_colour => 'black'
                            }

      assert_output_fixture 'circle = drawCircle(new GLatLng(-35.0, 18.0), 1000, 40, "red", 5, 0.7, "black", 1);',
                            script.record_for_test {
                              Google::Circle.new :location => location, :radius => 1000, :border_colour => 'red',
                                                 :border_width => 5, :border_opacity => 0.7,
                                                 :fill_colour => 'black', :fill_opacity => 1
                            }
    end 
  end

  
end