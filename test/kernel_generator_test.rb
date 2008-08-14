require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class KernelGeneratorTest < Test::Unit::TestCase

  def test_record
    script = Eschaton.javascript_generator

    script << "// This is before recording"
    record = script.record_for_test do
               script << "// This is within recording"
             end

    script << "// This is after recording"

    assert_equal "// This is before recording\n" << 
                 "// This is within recording\n" << 
                 "// This is after recording", script.generate    
    assert_equal "// This is within recording", record.generate
  end
  
  def test_if_statement
    script = Eschaton.javascript_generator
    assert_output_fixture :if_statement,
                          script.record_for_test{
                            script.if("x == 1"){
                              script.alert("x is 1!")
                            }
                          }

    script = Eschaton.javascript_generator     
    assert_output_fixture :if_statement_using_local_var,
                          script.record_for_test{
                            script.if("local_var"){
                              script.alert("there was a local var")
                            }
                          }
  end
  
  def test_if_statement
    script = Eschaton.javascript_generator
    assert_output_fixture :unless_statement,
                          script.record_for_test{
                            script.unless("x == 1"){
                              script.alert("x is not 1!")
                            }
                          }

    script = Eschaton.javascript_generator     
    assert_output_fixture :unless_statement_using_local_var,
                          script.record_for_test{
                            script.unless("local_var"){
                              script.alert("there was a local var")
                            }
                          }
  end
  
end