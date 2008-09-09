class Gravatar

  # Generates the url that represents the gravatar[http://www.gravatar.com/] icon.
  #
  # ==== Options:
  # * +email_address+ - Required. The email address of the gravatar
  # * +size+ - Optional. The size of the gravatar icon between 1 and 512 (pixels)
  # * +default+ - Optional. The default image to use should there be no gravatar for the given +email_address+
  def self.image_url(options)
    email_hash = Digest::MD5.hexdigest options.extract(:email_address)
    
    url_options = options.collect {|option, value|
                    "#{option}=#{value}"
                  }.join('&')

    url = "http://www.gravatar.com/avatar/#{email_hash}"
    url += "?#{url_options}" if url_options.not_blank?

    url
  end

end