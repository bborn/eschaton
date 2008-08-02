require File.dirname(__FILE__) + '/../../../test/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class KernelGeneratorTest < Test::Unit::TestCase

  def test_record
    script = Eschaton.javascript_generator

    assert_output_fixture :toggle_checkbox, 
                          script.record_for_test{
                            script.toggle_checkbox :register
                          }
  end

end