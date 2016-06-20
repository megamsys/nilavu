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
  class Team < ApiDispatcher

    attr_accessor   :id, :name, :created_at, :shared, :domain

    def initialize(team, opts={})
      opts ||= {}

      # Load the team
      @id = team.id if team.id
      @name = team.name if team.name
      @created_at = team.created_at.to_time.to_formatted_s(:rfc822) if team.created_at
      #@shared_with = team.shared
    end

    def find(opts={})
      find_domain(opts)
    end

    def find_domain(params={})
      result = api_request(DOMAIN, LIST, params.merge!({:org_id =>@id}))
      domains = result[:body] if result && result.is_a?(Hash)

      @domain = []

      domains.each do |r|
        @domain << r
      end
    end


    def last_used_domain
      return @domain.first if @domain
    end
    
    def to_s
      name
    end
  end
end
