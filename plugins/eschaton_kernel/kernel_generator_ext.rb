module KernelGeneratorExt

  # Evaluates the +script+ as javascript on the client.
  def eval(script)
    self << "eval(#{script.to_js});"
  end

  # Writes out a comment with the given +message+.
  #
  #  comment 'this code is awesome!' #=> '/* this code is awesome! */'
  def comment(message)
    self << "/* #{message} */"
  end
  
  # Writes out a javascript "if" statement using the given +condition+. Any code generated within the block will be placed
  # inside the "if" statement.
  #
  #  ==== Examples:
  #
  #  script.if("x == 1") do
  #    script.alert("x is 1!")
  #  end
  def if(condition)
    self << "if(#{condition}){"
    yield self
    self << "}"
  end
    
  # Writes out a javascript "unless" statement using the given +condition+. Any code generated within the block will be placed
  # inside the "unless" statement.
  #
  #  ==== Examples:
  #
  #  script.unless("x == 1") do
  #    script.alert("x is not 1!")
  #  end
  def unless(condition)
    self << "if(!(#{condition})){"
    yield self
    self << "}"
  end
    
  # Returns script that has been generated and allows for addtional +options+ regarding generation than the default +to_s+ method.
  #
  # Options:
  # :error_wrapping:: => Optional. Indicates if the script should be wrapped in try..catch blocks, defaulted to +false+.
  # :compact::        => Optional. Indicates if leading and trailing whitespace should be removed from each line, defaulted to +true+.
  # :inline::         => Optional. Indicates if new lines should be stripped from the generated script, defaulted to +false+.
  def generate(options = {})
    options.default! :error_wrapping => false, :compact => true, :inline => false
    options.assert_valid_keys :error_wrapping, :compact, :inline,
    
    reset_rjs_debug = ActionView::Base.debug_rjs
    
    ActionView::Base.debug_rjs = options[:error_wrapping]
    
    output = self.to_s
    output.gsub!(/^\s+|\s+$/, '') if options[:compact]
    output.gsub!("\n", ' ') if options[:inline]

    ActionView::Base.debug_rjs = reset_rjs_debug
    
    output
  end  
  
end