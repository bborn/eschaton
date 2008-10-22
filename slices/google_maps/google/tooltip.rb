module Google
  
  class Tooltip < MapObject
  
    # ==== Options:
    def initialize(options = {})
      options.default! :var => "tooltip_#{options[:on]}", :padding => 3

      super

      on = options[:on]
      content = OptionsHelper.to_content(options)

      script << "#{self} = new Tooltip(#{on}, #{content.to_js}, #{options[:padding]});"
    end

  end
end