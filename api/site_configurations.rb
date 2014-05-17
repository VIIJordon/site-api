require 'debugger'
module SiteApi
	class SiteConfiguration < Grape::API
		format :json
		version 'v1', using: :path, cascade: false
		namespace :site_configurations do 
			get do 
				Models::SiteConfiguration.all.desc(:site_key).as_json
			end
	    desc "Creates a site configuration.",
       params: {
       	site_configuration:
       		Models::SiteConfiguration.fields.dup.tap { |fields| fields.delete("_id") }
       	}
			post do
				json = Yajl::Parser.parse(request.body.read, symbolize_keys: true)
				site_configuration = Models::SiteConfiguration.create(json[:site_configuration])
				site_configuration.as_json
			end
			namespace "/:_id" do
				before do 
					@site_configuration = Models::SiteConfiguration.where(_id: params[:_id]).first
					error! 'Not Found', 404 unless @site_configuration
				end
	      desc "Returns a site configuration by id.",
	           params: { "_id" => { description: "site configuration id", required: true } }				
				get do 
					@site_configuration.as_json
				end
	      desc "Updates a widget by id.",
					params: {
						site_configuration: 
					 	Models::SiteConfiguration.fields.merge(
					    "_id" => { description: "site configuration id", required: true }
				 		)
					}
	      put do
					json = Yajl::Parser.parse(request.body.read, symbolize_keys: true)
					@site_configuration.update_attributes(json)
	      end

				delete do 
					@site_configuration.destroy
					@site_configuration.as_json
				end
			end
		end
	end
end
