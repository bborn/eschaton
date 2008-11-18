# Extend the unit testing tools with some CUSP goodness
module Test# :nodoc:
  module Unit # :nodoc:
    class TestCase # :nodoc:
  
      def assert_empty(array, message = nil)
        assert array.empty?, message
      end
  
      def assert_not_empty(array, message = nil)
        assert array.not_empty?, message
      end  
  
      def assert_blank(value, message = nil)
        assert value.blank?, message
      end
    
      def assert_not_blank(value, message = nil)
        assert value.not_blank?, message
      end    
    
      def assert_error(message, exception_class = RuntimeError, &block)
        exception = assert_raise exception_class, &block
        assert_equal(exception.message, message) unless exception.nil? || message.blank?
      end
  
      # Used to run something once
      def self.setup_once
        yield
      end
  
      def get_exception
        begin                    
          yield
        rescue => ex
        end
    
        ex
      end

      def assert_false(value)
        assert_equal false, value, "Expected '#{value}' to be false"
      end

      def assert_true(value)
        assert_equal true, value, "Expected '#{value}' to be true"
      end

    end
  end
end