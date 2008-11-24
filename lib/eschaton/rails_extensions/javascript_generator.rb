module ActionView # :nodoc:
  module Helpers # :nodoc:
    module PrototypeHelper # :nodoc:
      class JavaScriptGenerator # :nodoc:
  
        module GeneratorMethods # :nodoc:

          def <<(javascript)
            @recorder << javascript if @recorder
            @lines << javascript
      
            javascript
          end
          
          # TODO - Move this out once extending Generator methods is supported
          def replace_html(id, *options_for_render)
            options = *options_for_render
            if options.is_a?(Hash) && url = options.extract(:url)
              self.get(url) do |data|
                self << "$('#{id}').update(#{data});"
              end
            else
              call 'Element.update', id, render(options)
            end
          end          
          
        end

        # Allows for recording any script contained within the block passed to this method. This will return what was 
        # recorded in the form of a JavascriptGenerator.
        #
        # This is useful for testing and debugging output when generating script. 
        #
        # Example:
        #  script << "// This is before recording"
        #
        #  # record will containin the script generated within the block
        #  record = script.record_for_test do
        #             script << "// This is within recording"    
        #             script << "// Again, this is within a record"
        #           end
        #
        #  script << "// This is after recording"
        def record_for_test(&block)
          recorder = Eschaton.javascript_generator

          @recorder = recorder
          yield self
          @recorder = nil

          recorder
        end

        def self.extend_with_slice(extention_module)
          include extention_module
        end
      end
    end
  end
end