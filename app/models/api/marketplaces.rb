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
require 'singleton'

# this is a singleton which means we only load the marketplace once.
# the downside is if there is a change in marketplace then we need to restart nilavu.
module Api
  class Marketplaces < APIDispatch
    include Singleton

    attr_accessor :marketplace_groups
    attr_accessor :item


    def initialize
    end

    # Marketplace has a boquet of items.
    # each item has a catalog with catalog type and lots of plans
    #  -- :name         => 1-Ubuntu
    #     :cattype      => defines the logical types of category shortly named as cattype.
    #                      APP (an application)
    #                      SERVICE (a service like db, queue, analytics)
    #                      TORPEDO (a plain vm)
    #     :predef       => java, rails, play, nodejs, ubuntu, centos, coreos, debian
    #     :catalog      => defines a logical grouping of the cattypes.
    #                      :category => Torpedo
    #                                   App
    #                                   Service
    #                                   Collaboration
    #                                   Analytics
    def list(api_params)
      Rails.logger.debug "\033[36m>-- CACHE MKP'S: START\33[0m"
      group(load(api_params))
      Rails.logger.debug "\033[1m#{@marketplace_groups.to_yaml}\33[22m"
      Rails.logger.debug "\033[36m>-- CACHE MKP'S: END\033[0m"
      self
    end

    # This shows a single marketplace item. eg: 1-Ubuntu (Refer Marketplaces::list for more info)
    def show(api_params)
      raw = api_request(MARKETPLACES, SHOW,api_params)
      @item = raw[:body].lookup(api_params['id'])
      self
    end

    private

    def load(api_params)
      api_request(MARKETPLACES, LIST,api_params)[:body] unless @marketplace_groups
    end

    def group(raw)
      @marketplace_groups = Hash[raw.group_by(&:catorder).map { |k, v| [k, v.map { |h| h }] }].sort unless raw.nil?
    end
  end
end
