require 'digest/md5'

module Google
  
  # Allows for a gravatar[http://www.gravatar.com/] to be used as a Google::Icon. 
  # Instead of using this directly see Map#add_marker with the +gravatar+ option.
  class GravatarIcon < Icon
    
    # See Gravatar#image_url for valid options.
    def initialize(options = {})
      options.default! :var => 'icon'

      # TODO - uses hashish goodness here!
      gravatar_options = {}
      gravatar_options[:email_address] = options.extract_and_remove(:email_address) if options[:email_address]      
      gravatar_options[:size] = options.extract_and_remove(:size) if options[:size]
      gravatar_options[:default] = options.extract_and_remove(:default) if options[:default]

      options[:image] = Gravatar.image_url gravatar_options

      super
    end

  end
end