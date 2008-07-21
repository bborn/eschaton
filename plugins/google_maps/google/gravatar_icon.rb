require 'digest/md5'

module Google
  
  # Allows for a gravatar[http://www.gravatar.com/] to be used as a Google::Icon. 
  # Instead of using this directly see Map#add_marker with the +gravatar+ option.
  class GravatarIcon < Icon
    
    # * +email_address+ - Required. The email address of the gravatar
    # * +size+ - Optional. The size of the gravatar icon between 1 and 512 (pixels)
    # * +default+ - Optional. The default image to use should there be no gravatar for the given +email_address+
    def initialize(options = {})
      options.default! :var => 'icon'

      email_hash = Digest::MD5.hexdigest options.extract_and_remove(:email_address)

      gravatar_options = {}
      gravatar_options[:size] = options.extract_and_remove(:size) if options[:size]
      gravatar_options[:default] = options.extract_and_remove(:default) if options[:default]

      url_options = gravatar_options.collect {|option, value|
                      "#{option}=#{value}"
                    }.join('&')

      url = "http://www.gravatar.com/avatar/#{email_hash}"
      url += "?#{url_options}" if url_options.not_blank?

      options[:image] = url

      super
    end

  end
end