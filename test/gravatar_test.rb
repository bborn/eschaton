require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class GravatarTest < Test::Unit::TestCase

  def test_image_url                                    
    assert_equal "http://www.gravatar.com/avatar/9cbd681f28890259e8025d970bc515a3",
                  Gravatar.image_url(:email_address => 'yawningman@eschaton.com')

    assert_equal "http://www.gravatar.com/avatar/9cbd681f28890259e8025d970bc515a3?size=50",
                 Gravatar.image_url(:email_address => 'yawningman@eschaton.com', :size => 50)

    assert_equal "http://www.gravatar.com/avatar/9cbd681f28890259e8025d970bc515a3?default=http://localhost:3000/images/blue.png",
                 Gravatar.image_url(:email_address => 'yawningman@eschaton.com', 
                                    :default => 'http://localhost:3000/images/blue.png')

    assert_equal "http://www.gravatar.com/avatar/9cbd681f28890259e8025d970bc515a3?default=http://localhost:3000/images/blue.png&size=50",
                 Gravatar.image_url(:email_address => 'yawningman@eschaton.com', :default => 'http://localhost:3000/images/blue.png',
                                    :size => 50)
  end
  
end