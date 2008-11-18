class String # :nodoc:

  def quote
    "\"#{self}\""
  end

  def unquote
    self.gsub(/^"|"$/, '')
  end

  def unquote!
    self.gsub!(/^"|"$/, '')
  end

  def strip_each_line!
    self.gsub!(/^\s+|\s+$/, '')
  end

  # Escapes +self+ and returns the escaped string.
  def escape
    CGI.escape self
  end

end