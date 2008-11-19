class ScriptExpander

  def initialize
    @generator = Eschaton.javascript_generator
  end

  def to_s
    @generator.generate
  end

  def method_missing(method, *args, &block)
    @generator.send method, args, &block
  end

end