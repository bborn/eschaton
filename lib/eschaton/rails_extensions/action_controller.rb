module ActionController # :nodoc:
  class Base # :nodoc:
    before_filter :set_current_view

    def run_javascript(&block)
      render :update do |page|
        Eschaton.with_global_script page, &block
      end
    end

    def set_current_view
      Eschaton.current_view = @template
    end
  end
end