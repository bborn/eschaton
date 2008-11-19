class ScriptExpander

  def initialize
    @generator = Eschaton.javascript_generator
  end

  def to_s
    output = @generator.generate
    # TODO - This causes a blank output in the generator, investigate this
    output = ' ' if output.blank?

    output
  end

  def method_missing(method, *args, &block)
    @generator.send method, args, &block
  end

end