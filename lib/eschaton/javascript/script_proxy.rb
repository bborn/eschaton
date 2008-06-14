# Acts like a string of script
class ScriptProxy
  
  def initialize
    @script = ''
  end
  
  def write(code, options = {})
    options[:line_end] ||= :new_line

    @script << code.to_s
    @script << "\n" if options[:line_end] == :new_line
    
    code
  end
  
  alias << write
  
  def inline(code)
    write code, :line_end => :inline
  end
  
  def to_s
    @script
  end

end