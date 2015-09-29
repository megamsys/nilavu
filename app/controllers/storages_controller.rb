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
require 'json'

class StoragesController < ApplicationController
  respond_to :json, :js
  include MarketplaceHelper

  before_action :stick_keys, only: [:index ]

         ##
  ## index page get all marketplace items from storage(we use riak) using megam_gateway
  ## and show the items in order of category
  ##
  def index
    logger.debug '> Storages: index.'
    backup = Backup.new(session[:storage_access_key], session[:storage_secret_key])
    @buckets = backup.buckets_list
    @buckets
  end


  ##
  ## to show the selected marketplace catalog item, appears if there are credits in billing.
  ##
  def show

  end
##
  def getmsg
    logger.debug '>Controller getmsg called'
    new_backup = Backup.new("#{session[:storage_access_key]}", "#{session[:storage_secret_key]}")
	data = new_backup.buckets_list
    respond_with(data)
  end
end
