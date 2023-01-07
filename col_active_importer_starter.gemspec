require_relative "lib/col_active_importer_starter/version"

Gem::Specification.new do |spec|
  spec.name        = "col_active_importer_starter"
  spec.version     = ColActiveImporterStarter::VERSION
  spec.authors     = ["Benjamin CloudoLife"]
  spec.email       = ["benjamin@cloudolife.com"]
  spec.homepage    = "https://github.com/CloudoLife-RoR/col_active_importer_starter"
  spec.summary     = "col_active_importer_starter is a starter(or wrapper) to [active_importer."
  spec.description = "col_active_importer_starter makes full use of active_importer gem to import tabular data from spreadsheets or similar sources into Active Record models."
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "RubyGems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/CloudoLife-RoR/col_active_importer_starter"
  spec.metadata["changelog_uri"] = "https://github.com/CloudoLife-RoR/col_active_importer_starter"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails"

  spec.add_dependency "active_importer", ">= 0.2.6"

  spec.add_dependency "rubyXL"
end
