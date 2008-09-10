class SliceCloner # :nodoc:
  
  def self.clone(options)
    slices_directory = self.user_slices_directory
    working_area = "#{slices_directory}/working_area"

    FileUtils.rm_rf(working_area) && Dir.mkdir(working_area)

    `cd #{working_area} && /usr/local/git/bin/git clone #{options[:repo]}`

    Dir["#{working_area}/*/*"].each do |slice_dir|  
      basename = File.basename(slice_dir)
      slice_destination = "#{self.user_slices_directory}/#{basename}"

      puts "Cloning slice '#{basename}'"

      FileUtils.rm_rf slice_destination
      FileUtils.mv slice_dir, slice_destination
    end

    FileUtils.rm_rf(working_area)
  end 
  
  def self.user_slices_directory
    "#{RAILS_ROOT}/lib/eschaton_slices"
  end
   
end