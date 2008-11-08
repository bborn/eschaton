module ActionView # :nodoc:
  class Base # :nodoc:

    def self.extend_with_slice(extention_module)
      include extention_module
    end
  end
end