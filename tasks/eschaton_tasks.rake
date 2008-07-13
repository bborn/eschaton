eschaton_dir = "#{RAILS_ROOT}/vendor/plugins/eschaton"

desc 'Generate documentation for the eschaton plugin.'
Rake::RDocTask.new(:doc_eschaton) do |rdoc|
  rdoc.rdoc_dir = "doc/eschaton"
  rdoc.title    = 'eschaton doc'
  rdoc.options << '--line-numbers' << '--inline-source'
  
  google_maps_root = "#{eschaton_dir}/plugins/google_maps"
  
  rdoc.rdoc_files.include("#{google_maps_root}/README")
  
  rdoc.rdoc_files.include("#{google_maps_root}/**/*.rb")
end
