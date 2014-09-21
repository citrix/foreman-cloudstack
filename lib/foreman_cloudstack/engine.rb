require 'fast_gettext'
require 'gettext_i18n_rails'
require 'fog'

module ForemanCloudstack
	#Inherit from the Rails module of the parent app (Foreman), not the plugin.
	#Thus, inherits from ::Rails::Engine and not from Rails::Engine
	class Engine < ::Rails::Engine

		initializer 'foreman_cloudstack.register_gettext', :after => :load_config_initializers do |app|
			locale_dir    = File.join(File.expand_path('../../..', __FILE__), 'locale')
			locale_domain = 'foreman-cloudstack'

			Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
		end

		initializer 'foreman_cloudstack.register_plugin', :after => :finisher_hook do |app|
			Foreman::Plugin.register :foreman_cloudstack do
				requires_foreman '>= 1.5'
				# Register xen compute resource in foreman
				compute_resource ForemanCloudstack::Cloudstack
			end

		end

	end

	# extend fog cloudstack  and image models.
	require 'fog/cloudstack/models/compute/server'
	require File.expand_path('../../../app/models/concerns/fog_extensions/cloudstack/server', __FILE__)
	Fog::Compute::Cloudstack::Server.send(:include, ::FogExtensions::Cloudstack::Server)
end