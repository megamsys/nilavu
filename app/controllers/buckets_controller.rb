##
## Copyright [2013-2016] [Megam Systems]
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

class BucketsController < NilavuController
  respond_to :json, :js

  before_action :stick_ceph_keys, only: [:index, :create, :show, :upload, :destroy]

  def index
    if !session[:ceph_access_key].nil? && Backup::BackupUser.new.exists?(current_user.email)
      @bucket ||= Backup::Buckets.new(params).list
    else
      load_ceph(current_user)
      stick_ceph_keys
      redirect_to buckets_path if session[:ceph_access_key].nil?
      @bucket ||= Backup::Buckets.new(params).list
    end
    @usage  ||= Backup::BackupUser.new.usage(current_user.email)
  end

  def create
    begin
      Backup::Buckets.new(params).create(params[:id])
      @bucket ||= Backup::Buckets.new(params).list
      redirect_to(buckets_path, :flash => { :success => "#{params['id']} created successfully."}, format: 'js')
    rescue Exception => e
      redirect_to(buckets_path, :flash => { :error => "Bucket name not available! Try different bucket name!"}, format: 'js')
    end
  end

  def show
    logger.debug '> Buckets: show.'
    #@objects = BucketObjects.new(params).list_detail
    #@bucket_name = params["id"]
  end

  def destroy
  end

end
