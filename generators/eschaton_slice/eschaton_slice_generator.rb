class EschatonSliceGenerator < Rails::Generator::NamedBase
  
  def manifest
    record do |m|
      new_slice_directory = "#{SliceCloner.relative_user_slices_directory}/#{self.name}"

      m.directory new_slice_directory
      m.file "slice.rb", "#{new_slice_directory}/#{self.name.underscore}.rb"
    end
  end

end