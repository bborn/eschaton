require File.dirname(__FILE__) + '/test_helper'

Test::Unit::TestCase.output_fixture_base = File.dirname(__FILE__)

class GravatarIconTest < Test::Unit::TestCase

  def test_initialize
    Eschaton.with_global_script do |script|
      assert_output_fixture :gravatar, 
                             script.record_for_test {
                               Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com'
                             }

      assert_output_fixture :gravatar_with_size, 
                            script.record_for_test {
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :size => 50
                            }

      assert_output_fixture :gravatar_with_default_icon, 
                            script.record_for_test {
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :default => 'http://localhost:3000/images/blue.png'
                            }

      assert_output_fixture :gravatar_with_size_and_default_icon, 
                            script.record_for_test {
                              Google::GravatarIcon.new :email_address => 'yawningman@eschaton.com', :default => 'http://localhost:3000/images/blue.png',
                                                       :size => 50
                            }
    end
  end

end
