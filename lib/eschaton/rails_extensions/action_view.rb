module ActionView # :nodoc:
  class Base # :nodoc:

    # Extends the ActionView::Base by including the +extention_module+.
    def self.extend_with_slice(extention_module)
      include extention_module
    end
  end
end