require File.dirname(__FILE__) + '/../../../test/test_helper'

class KernelGeneratorTest < Test::Unit::TestCase

  def test_start_recording
    script = Eschaton.javascript_generator

    script << "// This is before recording"
    record = script.start_recording do
               script << "// This is within recording"
             end

    script << "// This is after recording"

    assert_equal "// This is before recording\n" << 
                 "// This is within recording\n" << 
                 "// This is after recording", script.generate    
    assert_equal "// This is within recording", record.generate
  end
  
end