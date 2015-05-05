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
# A mixin that can be used for controls operations like
#  create:
#          - CREATE an assembly which submits a /requests to the gateway
#          - CREATE  lifecyle ops like START, STOP, RESTART, DELETE which submits /catrequests to gateway
#  destroy:
#          - DESTROY an assembly  or catalog.
module Pilotable
  extend ActiveSupport::Concern

  included do
    attr_writer :create, :destroy
  end

  def create
    puts "--- requests hack --"
    puts "--- catrequests hack --"
  end

  #destroy
  def destroy
    puts "--- catrequests hack --"
  end

end
