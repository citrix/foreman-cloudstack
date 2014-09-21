$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foreman_cloudstack/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
	s.name        = "foreman_cloudstack"
	s.version     = ForemanCloudstack::VERSION
	s.authors     = ["Amir Nashat"]
	s.email       = ["amir.nashat@citrix.com"]
	s.homepage    = "http://github.com/theforeman/foreman-cloudstack"
	s.summary     = "Provision and manage a Cloudstack Server from Foreman"
	s.description = "Provision and manage a Cloudstack Server from Foreman."
	s.licenses    = ["GPL-3"]

	s.add_development_dependency('rake')

	s.files = Dir["{app,config,db,lib,locale}/**/*", "LICENSE", "Rakefile", "README.md"]
	s.test_files = Dir["test/**/*"]

	s.add_dependency "fog"
end