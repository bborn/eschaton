module ActionController # :nodoc:
  class Base # :nodoc:
    before_filter :set_current_view

    def set_current_view
      Eschaton.current_view = @template
    end

    def self.extend_with_slice(extention_module)
      include extention_module
    end

  end
end