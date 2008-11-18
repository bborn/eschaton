class Hash
  alias extract delete  
  alias extract_and_remove delete
  
  SPACE = {:text => ' ', :html => '&nbsp;'}
  NEWLINE = {:text => '', :html => '<br/>'} #TODO use \n
  
  # Defaults key values in a hash that are not present. Works like #merge but does not overwrite
  # existing keys. This is usefull when using options arguments
  def default!(options = {})
    options.each do |key, value|      
      self[key] = value if self[key].nil?
    end
    
    self
  end
  
  #TODO if print => true, return self => HOW since return val being used for recursion
  def tap(options = {})
    options = {:as => :text, :indent => 0, :print => true}.merge(options)
    
    self.collect{|key, value| 
      spaces = SPACE[options[:as]] * (options[:indent] * 2)
      if value.kind_of?(Hash)
        s = "#{spaces}#{key} => #{NEWLINE[options[:as]]}" 
        
        puts s if options[:print] == true
        indented_options = options.merge({:indent => options[:indent] + 1})
        indented = value.tap(indented_options)
        s += indented
      else  
        value = value.strftime("%Y/%m/%d") if value.kind_of?(Time)
        s = "#{spaces}#{key} => #{value} #{NEWLINE[options[:as]]}"
        puts s if options[:print] == true
      end
      s
    }.join('\n')
  end

  def filter(*params)
    h = Hash.new
    params.each {|key| h[key] = self[key]}
    h
  end
  
  def attr_match?(obj) #TODO returning
   outcome = true
   results = self.each do |key, value|
     outcome &= obj.send(key) == value
   end
   outcome
  end
  
  def first_pair
    key, value = '', ''
    self.each{|k ,v|
      key = k.to_s
      value = v
      break
    }
    
    [key, value]
  end

end
