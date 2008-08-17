module Google

  class OptionsHelper # :nodoc:

    def self.to_content(options)
      if options[:partial]
        Eschaton.current_view.render options
      else
        options[:text]
      end
    end

  end

end