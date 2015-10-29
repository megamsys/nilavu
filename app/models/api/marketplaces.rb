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
require 'singleton'

# this is a singleton which means we only load the marketplace once.
# the downside is if there is a change in marketplace then we need to restart nilavu.
module Api
  class Marketplaces < APIDispatch
    include Singleton
    include MarketplaceHelper

    attr_reader :mkp_grouped
    attr_reader :mkp

    ONE = 'one'.freeze
    DOCKER           =  'docker'.freeze
    BAREMETAL        =  'baremetal'.freeze

    def initialize
      @mkp_grouped = {}
      @mkp = {}
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
    #                      :category => Dew
    #                                   Starter Packs
    #                                   App Boilers
    #                                   Platform
    #                                   Analytics
    def list(api_params, &_block)
      Rails.logger.debug "\033[36m>-- MKP'S: START\33[0m"
      @mkp_grouped = group(load_api_params)
      Rails.logger.debug "\033[1m#{@mkp_grouped.to_yaml}\33[22m"
      Rails.logger.debug "\033[36m>-- MKP'S: END\033[0m"
      yield self if block_given?
      self
    end

    # This shows a single marketplace item. eg: 1-Ubuntu (Refer Marketplaces::list for more info)
    def show(api_params, &_block)
      raw = api_request(MARKETPLACES, SHOW,api_params)
      @mkp = raw[:body].lookup(api_params['id'])
      yield self if block_given?
      self
    end

    private
    def load(api_params)
      api_request(MARKETPLACES, LIST,api_params)[:body] if @mkp_grouped.empty?
    end
    def group(raw)
      @mkp_grouped = Hash[raw.group_by(&:order).map { |k, v| [k, v.map { |h| h }] }].sort unless raw.nil?
    end
  end
end
