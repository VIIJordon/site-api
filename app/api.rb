module SiteApi
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::SiteApi::SiteConfiguration
    add_swagger_documentation api_version: 'v1'
  end
end
