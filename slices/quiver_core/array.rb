class Array
  #TODO metafy
  #attributize {:find , :find_all}
  
  # Aliases array indexes with english terms. Add terms as needed to the hash
  {1 => :second, 2 => :third, 3 => :forth, 4 => :fifth}.each do |index, method_alias|
    define_method method_alias do
      self[index]
    end
  end
  
  def to_csv
    self.collect(&:quote).join(',')
  end
  
  def find_(options = {}, &block) #vs find/detect
    if block_given?
      find(&block)
    else
      self.find do |element|
       options.attr_match?(element)    
      end 
    end
  end
  
  def find_all_(options = {}, &block) #vs find_all/select
    if block_given?
      find_all(&block)
    else
      self.find_all do |element|
       options.attr_match?(element)    
      end       
    end
  end

  def tap
    self.each{|element| 
      if element.respond_to?(:tap)
        element.tap 
      else
        p element  
      end  
    }
    self
  end
  
	def wrap_chunks(size, open_tag, close_tag)
		output = ""
		each_with_chunk_markers(size){|e, must_open_new, must_close_prev|
			output += open_tag if must_open_new
			output += yield(e, must_open_new, must_close_prev)
			output += close_tag if must_close_prev
		}
		output
	end	
   
  # TODO - Update code using this and remove. See Object#arify for a more OO form
  def self.arify(element)
    if element.is_a?(Array)
      element
    else
      [element]
    end  
  end
  
  def prepend(value)
    self.insert(0, value)
  end
  
  def not_empty?
    !self.empty?
  end
    
private
	def each_with_chunk_markers(size)
		self.each_with_index {|e, i|
			must_open_new = (i % size == 0) #start of a new chunk
			must_close_prev = ((i+1) % size == 0) || ((i+1) == self.size) #(if next element is start of a new chunk) || (this element is the last in the array)
			
			yield e, must_open_new, must_close_prev
		}
	end
end
