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
class Discounts < BaseFascade

attr_reader :discounts_collection

  def initialize()
    @discounts_collection = []
    super(true)
  end

  def create(api_params, &block)
   Rails.logger.debug "> Discounts: create"
    api_request(bld_discount(api_params), DISCOUNTS, CREATE)  
      yield self  if block_given?
    return self
  end

  def update(api_params, &block)
    api_request(api_params, DISCOUNTS, UPDATE)
    yield self if block_given?
    return self
  end

  def list(api_params, &block)
    puts bld_discount(api_params)
    Rails.logger.debug "> Discounts: List"
    raw = api_request(bld_discount(api_params), DISCOUNTS, LIST)
    puts "---------------------------------"
    puts raw[:body]
    puts "---------------------------------"
    @discounts_collections = raw[:body] unless raw == nil
    yield self if block_given?
    return self
  end
  
private
def bld_discount(api_params)
  disc_params = {
    :accounts_id => api_params[:accounts_id],
    :bill_type => api_params[:bill_type],
    :code => api_params[:code],
    :status => api_params[:status],
    :email => api_params[:email],
    :api_key => api_params[:api_key]           
  }
end
  
end
