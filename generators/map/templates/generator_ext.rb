module <%= slice_class %>GeneratorExt

  def map
    @map ||= Google::Map.existing(:var => 'map')
  end

end