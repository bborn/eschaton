require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class LineTest < Test::Unit::TestCase

  def test_with_marker
    script = Eschaton.with_global_script do |script|
      marker = Google::Marker.new :location => :center

      tooltip = Google::Tooltip.new :on => marker
    end    
    
    puts script.to_s
  end

end