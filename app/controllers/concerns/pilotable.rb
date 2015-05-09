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
#          - CREATE  lifecyle ops like START, STOP, RESTART, DELETE which submits /catrequests to gateway
#  destroy:
#          - DESTROY an assembly  or catalog.
module Pilotable
  extend ActiveSupport::Concern

  included do
    attr_writer :create, :destroy
  end

  #this action gets called prior to a start, stop, restart, delete operation
  # a confirmation is got from the user to perform the same.
  def precreate
    @id = params[:id]
    @name = params[:name]
    @command = params[:command]
    @cattype = params[:cattype]
    respond_to do |format|
      format.js {
        respond_with(@id, @name, @command, @type, :layout => !request.xhr? )
      }
    end
  end

  #this action performs a start, stop, restart operation
  def create
    logger.debug "> Pilotable: create"
    Requests.new.catreqs(params)
  end

  #this action perfroms a delete operation.
  def destroy
    logger.debug "> Pilotable: destroy"
    Requests.new.reqs(params)
  end

end
