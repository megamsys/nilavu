##
## Copyright [2013-2015] [Megam Systems]
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
require 'json'

class Organizations < BaseFascade

  attr_reader :orgs

  def initialize
    @orgs = []
  end

  #we call the api, and list all the organization name, create_at time in a hashmap.
  def list(api_params, &block)
    res = api_request(api_params, ORGANIZATION, LIST)
    

res[:body].each do |one_org|

     
        @orgs << {:id => one_org.id, :name => one_org.name, :created_at => one_org.created_at.to_time.to_formatted_s(:rfc822), :related_orgs => one_org.related_orgs}
    end
    @orgs = @orgs.sort_by {|vn| vn[:created_at]}

    yield self if block_given?
    return self
  end

  def update(api_params, &block)
    res = api_request(api_params, ORGANIZATION, UPDATE)
  end

  #domain isn't linked to any org/account, we need to hack this method later.
  def showDomains(api_params, &block)

  end
end
