##
## Copyright [2013-2016] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
module Api
  class Organizations < APIDispatch
    attr_reader :orgs

    class OrganizationNotFound < Nilavu::MegamGWError; end

    def initialize
      @orgs = []
    end

    #we call the api, and list all the organization name, create_at time in a hashmap.
    def list(api_params, &block)
      res = api_request(ORGANIZATION, LIST, api_params)
      res[:body].each do |one_org|
        @orgs << {:id => one_org.id, :name => one_org.name, :created_at => one_org.created_at.to_time.to_formatted_s(:rfc822), :related_orgs => one_org.related_orgs}
      end

      yield self if block_given?
      return self
    end

    def update(api_params, &block)
      res = api_request(ORGANIZATION, UPDATE,api_params)
    end

    def first
      og = @orgs.sort_by {|vn| vn[:created_at]} if @orgs
      if og && og.length > 0
        return og.first[:id]
      end
      raise Api::Organizations::OrganizationNotFound, "You are not part of any organization. Maybe you are not onboarded."
    end
  end
end
