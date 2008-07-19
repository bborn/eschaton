require File.dirname(__FILE__) + '/../../../test/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)
    
class GoogleGeneratorExtTest < Test::Unit::TestCase
  
  def test_if_google_compatible
    Eschaton.with_global_script do |script|
      
      assert_output_fixture :if_google_compatible_no_body, script.record_for_test {
                                                             script.if_google_compatible {}
                                                           }
                                                           
     assert_output_fixture :if_google_compatible_with_body, script.record_for_test {
                                                            script.if_google_compatible do
                                                              script.comment "This is some test code!"
                                                              script.alert("Hello!")
                                                            end
                                                          }
    end
  end

  def test_google_map_script
    Eschaton.with_global_script do |script|
      
      assert_output_fixture :google_map_script_no_body, script.record_for_test {
                                                             script.google_map_script {}
                                                           }

      assert_output_fixture :google_map_script_with_body, script.record_for_test {
                                                            script.google_map_script do
                                                              script.comment "This is some test code!"
                                                              script.alert("Hello!")
                                                            end
                                                          }
      
    end
  end

  def test_google_map_script
    generator = Eschaton.javascript_generator

    assert_nil JavascriptObject.global_script

    generator.mapping_script do |script|
      assert_not_nil JavascriptObject.global_script      
      assert_equal generator, script
    end

    assert_nil JavascriptObject.global_script     
  end

end
