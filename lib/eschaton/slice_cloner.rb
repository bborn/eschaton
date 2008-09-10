class SliceCloner # :nodoc:
  
  def self.clone(options)
    working_area = "#{self.absolute_user_slices_directory}/working_area"

    FileUtils.rm_rf(working_area) && Dir.mkdir(working_area)

    `cd #{working_area} && /usr/local/git/bin/git clone #{options[:repo]}`

    Dir["#{working_area}/*/*"].each do |slice_dir|  
      basename = File.basename(slice_dir)
      slice_destination = "#{self.absolute_user_slices_directory}/#{basename}"

      puts "Cloning slice '#{basename}'"

      FileUtils.rm_rf slice_destination
      FileUtils.mv slice_dir, slice_destination
    end

    FileUtils.rm_rf(working_area)
  end 
  
  def self.absolute_user_slices_directory
    "#{RAILS_ROOT}/#{self.relative_user_slices_directory}"
  end
  
  def self.relative_user_slices_directory
    "lib/eschaton_slices"
  end
   
end