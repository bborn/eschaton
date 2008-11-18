class Array # :nodoc:
  
  # Aliases array indexes with english terms. Add terms as needed to the hash
  {1 => :second, 2 => :third, 3 => :forth, 4 => :fifth}.each do |index, method_alias|
    define_method method_alias do
      self[index]
    end
  end

  def not_empty?
    !self.empty?
  end

end
