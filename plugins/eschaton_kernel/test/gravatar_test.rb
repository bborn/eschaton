require File.dirname(__FILE__) + '/../../../test/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class KernelGeneratorTest < Test::Unit::TestCase

  def test_image_url                                    
    assert_equal "http://www.gravatar.com/avatar/4761a1638aa18f8cb2d21d9340ce92b1",
                  Gravatar.image_url(:email_address => 'karadanais@gmail.com')

    assert_equal "http://www.gravatar.com/avatar/4761a1638aa18f8cb2d21d9340ce92b1?size=50",
                 Gravatar.image_url(:email_address => 'karadanais@gmail.com', :size => 50)

    assert_equal "http://www.gravatar.com/avatar/4761a1638aa18f8cb2d21d9340ce92b1?default=http://localhost:3000/images/blue.png",
                 Gravatar.image_url(:email_address => 'karadanais@gmail.com', 
                                    :default => 'http://localhost:3000/images/blue.png')

    assert_equal "http://www.gravatar.com/avatar/4761a1638aa18f8cb2d21d9340ce92b1?default=http://localhost:3000/images/blue.png&size=50",
                 Gravatar.image_url(:email_address => 'karadanais@gmail.com', :default => 'http://localhost:3000/images/blue.png',
                                    :size => 50)
  end
  
end