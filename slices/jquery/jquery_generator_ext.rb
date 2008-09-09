module JqueryGeneratorExt
  
  # Gives control of the $ variable back to whichever library first implemented it.
  # This helps to make sure that jQuery doesn't conflict with the $ object of other libraries
  def avoid_conflicts!
    self << "jQuery.noConflict();"
  end
  
  # Any script that is added within the block will execute when the document is ready.
  #
  #  when_document_ready do
  #    script << "var i = 1;"
  #    script << "alert(i);"
  #    script.alert('hello world!')
  #  end
  def when_document_ready
    self << "jQuery(document).ready(function() {"
    yield self
    self << "})"
  end

  # Makes a get request to the +url+ and yields the +data+ variable in which the contents of the request are stored.
  # See Escahton.url_for_javascript for +url+ options.
  def get(url)
    self << "jQuery.get(#{Eschaton.url_for_javascript(url)}, function(data) {"
    yield :data
    self <<  "});"    
  end

  # Performs an http post using either the +form+ or the +params+ to the given +url+.
  #
  # ==== Options:
  # * +url+ - Required. The url to post to, see Escahton.url_for_javascript for supported options.
  # * +form+ - Optional. The id of the form to post.
  # * +params+ - Optional. Parameters to post
  # * +eval_response+ - Optional. Indicates if the response of the post should be evaled and executed client side.
  def post(options)
    options.assert_valid_keys :url, :form, :params, :eval_response
    options.default! :form => nil, :params => {}, :eval_response => false

    if Eschaton.current_view.protect_against_forgery?
      options[:url][:authenticity_token] = Eschaton.current_view.form_authenticity_token
    end

    form_fields = if options[:form]
                    "jQuery('##{options[:form]}').serialize()"
                  else
                    options[:params].to_js
                  end

    url = Eschaton.url_for_javascript(options[:url])
    self << "jQuery.post(#{url}, #{form_fields}, function(data) {"

    yield :data if block_given?

    self.eval(:data) if options[:eval_response]
    
    self <<  "});"    
  end
  
  # Performs an http post and evaluates the response as javascript. Supports the same options as post.
  def post_and_run(options)
    options[:eval_response] = true

    self.post options
  end
  

end