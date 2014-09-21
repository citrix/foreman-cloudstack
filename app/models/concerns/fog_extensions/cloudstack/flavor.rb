module FogExtensions
	module Cloudstack
		module Flavor
			extend ActiveSupport::Concern

			def to_label
				"#{id} - #{name}"
			end

			def to_s
				name
			end
		end
	end
end