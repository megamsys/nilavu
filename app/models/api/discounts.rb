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
module Api
  class Discounts < APIDispatch
    attr_reader :discounts_collections

    def initialize()
      @discounts_collections = []
      super(true)
    end

    def create(api_params, &block)
      Rails.logger.debug "> Discounts: create"
      api_request(DISCOUNTS, CREATE,api_params)
      yield self if block_given?
      return self
    end

    def update(api_params, &block)
      api_request(DISCOUNTS, UPDATE,api_params)
      yield self if block_given?
      return self
    end

    def list(api_params, &block)
      Rails.logger.debug "> Discounts: List"
      raw = api_request(DISCOUNTS, LIST,api_params)
      @discounts_collections = raw[:body] unless raw == nil
      yield self if block_given?
      return self
    end
  end
end
