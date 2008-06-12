class Hash
  
  def to_location
    Google::Location.new(:latitude => self[:latitude], :longitude => self[:longitude])
  end
  
end