module SiteApi
	module Models
		class SiteConfiguration
		  include Mongoid::Document
		  include Mongoid::Timestamps

		  field :site_key, type: String, description: "key to look up configuration"
		end
	end
end