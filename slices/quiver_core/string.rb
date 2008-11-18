class String

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

end