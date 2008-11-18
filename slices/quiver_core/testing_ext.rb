# Extend the unit testing tools with some CUSP goodness

class Test::Unit::TestCase
  
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
  
  # Asserts that there are *no* active record errors on the given list of +fields+.
  def assert_valid_fields(object, *fields)
    fields.each do |field|
      assert_equal nil, object.errors.on(field), "Unexpected error on field #{field}"
    end
  end

  # Asserts that there are active record errors on the given list of +fields+.
  def assert_invalid_fields(object, *fields)
    fields.each do |field|
      assert object.errors.on(field), "Expected error on field #{field}"
    end
  end
  
  def assert_false(value)
    assert_equal false, value, "Expected '#{value}' to be false"
  end

  def assert_true(value)
    assert_equal true, value, "Expected '#{value}' to be true"
  end
  
  def assert_difference(object, method = nil, difference = 1)
    initial_value = object.send(method)
    yield
    assert_equal initial_value + difference, object.send(method), "#{object}##{method}"
  end

  def assert_no_difference(object, method, &block)
    assert_difference object, method, 0, &block
  end

  def check_require(model_name, attribute)
    assert_no_difference model_name.to_s.classify.constantize, :count do
      model = send("create_#{model_name.to_s}", attribute => nil)
      assert model.errors.on(attribute)
    end
  end

  def check_not_require(model_name, attribute)
    assert_difference model_name.to_s.classify.constantize, :count do
      model = send("create_#{model_name.to_s}", attribute => nil)
      assert !model.errors.on(attribute)
    end
  end

  def check_require_unique(model_name, attribute, existing)
    model_class = model_name.to_s.classify.constantize
    assert_not_nil model_class.send("find_by_#{attribute.to_s}", existing)
    assert_no_difference model_class, :count do
      model = send("create_#{model_name.to_s}", attribute => existing)
      assert model.errors.on(attribute)
    end
  end

  def check_create(model_name, options = {})
    model = nil
    assert_difference model_name.to_s.classify.constantize, :count do
      model = send("create_#{model_name.to_s}", options)
      assert !model.new_record?, "#{model.errors.full_messages.to_sentence}"
    end
    model
  end
    
end
