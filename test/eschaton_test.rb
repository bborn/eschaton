require File.dirname(__FILE__) + '/test_helper'

class EschatonTest < Test::Unit::TestCase
    
  def test_url_for        
    puts Eschaton.url_for(:controller => :marker, :action => :show, :id => '#marker.id', :other => 'sss')
    
    puts Eschaton.url_for(:controller => :location, :action => :create, :name => 'My Location',
                          :latitude => '#location.lat()', :longitude => '#longitude.long()')
  end
  
end