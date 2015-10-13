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
class Requests < BaseFascade
  include MarketplaceHelper

  attr_reader :req_submitted

  def initialize()
    @req_submitted = []
  end

  #This  creates a /requests
  # used during CREATION and DELETE
  def reqs(api_params, &block)
    raw = api_request(api_params, REQUESTS, CREATE)
    @req_submitted =  raw[:body]
    yield self  if block_given?
    return self
  end


end
