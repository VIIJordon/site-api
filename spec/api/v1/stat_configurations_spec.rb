require 'spec_helper'

describe SiteApi::API do
  include Rack::Test::Methods

  def app
    SiteApi::API
  end
  it "returns an empty collection of site_configurations" do
    get "/api/v1/site_configurations/"
    last_response.status.should == 200
    last_response.body.should == "[]"
  end

  it "returns 404 if site_configuration does not exist" do
    get "/api/v1/site_configurations/invalid/"
    last_response.status.should == 404
    last_response.body.should == '{"error":"Not Found"}'
  end

  it "creates a site_configuration" do
    expect {
      post "/api/v1/site_configurations", {
      	site_configuration: {
      		site_key: 'test.com'
      	}
      }.to_json
      last_response.status.should == 201
    }.to change(SiteApi::Models::SiteConfiguration, :count).by(1)
    site_configuration = SiteApi::Models::SiteConfiguration.last
    site_configuration.site_key.should == "test.com"
  end
  context "with site configurations" do
    before do
      @config1 = SiteApi::Models::SiteConfiguration.create!(site_key: 'one')
      @config2 = SiteApi::Models::SiteConfiguration.create!(site_key: 'two')
    end
    it "updates a site configuration" do
      expect {
        put "/api/v1/site_configurations/#{@config1._id}", {
        	site_key: 'updated'
        }.to_json
        last_response.status.should == 200
      }.to_not change(SiteApi::Models::SiteConfiguration, :count)
      @config1.reload
      @config1.site_key.should == "updated"
    end
    it "destroys a site configuration" do
      expect {
        delete "/api/v1/site_configurations/#{@config1.id}"
        last_response.status.should == 200
      }.to change(SiteApi::Models::SiteConfiguration, :count).by(-1)
    end

  end
end