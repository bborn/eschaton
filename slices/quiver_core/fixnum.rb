class Fixnum
  
  def pad_left(length, pad_string)
    self.to_s.pad_left(length, pad_string)
  end
  
  def to_dec
    return BigDecimal.new(self.to_s)
  end
end