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
class Marketplaces < BaseFascade
  include MarketplaceHelper

  attr_reader :order
  attr_reader :categories
  attr_reader :mkp_collection
  attr_reader :mkp
  
  def initialize()
     @order = []
     @categories = []
     @mkp_collection = []
     @mkp = {}
  end

  def list(api_params, &block)
    raw = api_request(api_params, MARKETPLACES, LIST)
    @mkp_collection =  raw[:body] unless raw == nil
    @order = raw[:body].map {|c|
      c.name
    } unless raw == nil
     @order = @order.sort_by {|elt| ary = elt.split("-").map(&:to_i); ary[0] + ary[1]} unless raw == nil
     @categories = raw[:body].map {|c| c.appdetails[:category]} unless raw == nil
     @categories = @categories.uniq unless raw == nil
    yield self  if block_given? 
    return self
  end
  
  def show(api_params, &block)
     raw = api_request(api_params, MARKETPLACES, SHOW)  
     @mkp = raw[:body].lookup(api_params["id"])  
     yield self  if block_given?
     return self
  end

end