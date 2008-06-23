require File.dirname(__FILE__) + '/test_helper'

class EschatonTest < Test::Unit::TestCase
  
  def test_current_view
    assert_not_nil Eschaton.current_view
  end
  
  def test_javascript_generator
    generator = Eschaton.javascript_generator

    assert_equal ActionView::Helpers::PrototypeHelper::JavaScriptGenerator, generator.class
    assert generator.repond_to?(:generate)
    assert generator.class.respond_to?(:extend_with_plugin)
    assert generator.repond_to?(:comment)
  end
  
  def test_global_script_with_no_script
    assert_nil JavascriptObject.global_script
  
    return_script = Eschaton.with_global_script do |script|
                      assert_not_nil script
                      assert_not_nil JavascriptObject.global_script
                      assert_equal script, JavascriptObject.global_script                      
                    end

    assert_nil JavascriptObject.global_script
    assert_not_nil return_script
  end
  
  def test_global_script_with_script
     generator = Eschaton.javascript_generator

     assert_nil JavascriptObject.global_script
          
     return_script = Eschaton.with_global_script(generator) do |script|
                       assert_not_nil script
                       assert_not_nil JavascriptObject.global_script
       
                       assert_equal generator, script
                       assert_equal generator, JavascriptObject.global_script
                       assert_equal script, JavascriptObject.global_script
                     end
     
     assert_nil JavascriptObject.global_script
     assert_equal generator, return_script
  end
  
  def test_url_for
    assert_equal "'/posts/create'", Eschaton.url_for_javascript(:controller => :posts, :action => :create)
    assert_equal "'/posts/update/1'", Eschaton.url_for_javascript(:controller => :posts, :action => :update, :id => 1)
    assert_equal "'/posts/by_name?name=Joe&surname=Soap'", Eschaton.url_for_javascript(:controller => :posts, :action => :by_name, 
                                                                                       :name => 'Joe', :surname => 'Soap')    
    
    assert_equal "'/marker/create?latitude=' + location.lat() + '&longitude=' + location.lng() + ''",
                 Eschaton.url_for_javascript(:controller => :marker, :action => :create, :latitude => '#location.lat()', 
                                             :longitude => '#location.lng()')
    
   assert_equal "'/marker/create/' + marker.id + '?name=My+Marker&title=' + maker.title + ''",
                Eschaton.url_for_javascript(:controller => :marker, :action => :create, :id => '#marker.id', 
                                            :title => '#maker.title', :name => 'My Marker')
  end
  
end