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

#this is a singleton which means we only load the marketplace once.
#the downside is if there is a change in marketplace then we need to restart nilavu.
class Marketplaces < BaseFascade
  include Singleton
  include MarketplaceHelper

  attr_reader :mkp_grouped
  attr_reader :mkp_collection
  attr_reader :mkp

  def initialize()
     @mkp_collection = []
     @mkp_grouped = {}
     @mkp = {}
  end

  #Marketplace has a boquet of items.
  # each item has a catalog with catalog type and lots of plans
  #  -- :name         => 1-Ubuntu
  #     :cattype      => defines the logical types of category shortly named as cattype.
  #                      APP (an application)
  #                      SERVICE (a service like db, queue, analytics)
  #                      DEW (a plain vm)
  #     :predef       => java, rails, play, nodejs, ubuntu, centos, coreos, debian
  #     :catalog      => defines a logical grouping of the cattypes.
  #                      :category => Dew
  #                                   Starter Packs
  #                                   App Boilers
  #                                   Platform
  #                                   Analytics
  def list(api_params, &block)
    raw = api_request(api_params, MARKETPLACES, LIST)
    @mkp_collection =  raw[:body] unless raw == nil

    @mkp_grouped = Hash[@mkp_collection.group_by{ |tmp| tmp.catalog[:category] }.map{|k,v| [k,v.map{|h|h}]}]

    yield self  if block_given?
    return self
  end

  # This shows a single marketplace item. eg: 1-Ubuntu (Refer Marketplaces::list for more info)
  def show(api_params, &block)
     raw = api_request(api_params, MARKETPLACES, SHOW)
     @mkp = raw[:body].lookup(api_params["id"])
     yield self  if block_given?
     return self
  end

end
