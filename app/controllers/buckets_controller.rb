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
## WITHOUT WARRANTIE  S OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
require 'json'

class BucketsController < ApplicationController

  respond_to :json, :js

  before_action :stick_storage_keys, only: [:index, :create, :show, :upload]
  ##
  ## index page get all marketplace items from storage(we use riak) using megam_gateway
  ## and show the items in order of category
  ##
  def index
    logger.debug '> Buckets: index.'
    backup = Backup.new(params[:accesskey], params[:secretkey], Ind.backup.host)
    @buckets = backup.buckets_list
    backup_client = BackupUser.new(Ind.backup.host, Ind.backup.username, Ind.backup.password)
    @backup_usage = backup_client.account_usage(session[:email])
  end

  def create
    logger.debug '> Buckets: create.'
    backup = Backup.new(params[:accesskey], params[:secretkey], Ind.backup.host)
    backup.bucket_create(params["bucket_name"])
    @msg = { title: "Storage", message: "#{params["bucket_name"]} created successfully. ", redirect: '/', disposal_id: 'create_bucket' }
  end

  ##
  ## to show the selected marketplace catalog item, appears if there are credits in billing.
  ##
  def show
    logger.debug '> Buckets: show.'
    @objects = []
    backup = Backup.new(params[:accesskey], params[:secretkey], Ind.backup.host)
    backup.objects_list(params["id"]).each do |bkt|
      obj = backup.object_get(params["id"], bkt.key)
      @objects.push({:key => "#{obj.key}", :object_name => "#{obj.full_key}", :size => "#{obj.size}", :content_type => "#{obj.content_type}", :last_modified => "#{obj.last_modified}", :download_url => "#{obj.temporary_url}" })
    end
    @bucket_name = params["id"]
  end

end
