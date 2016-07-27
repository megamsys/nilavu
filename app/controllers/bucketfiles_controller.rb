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
require 'backup_restore/bucketfiles_lister'
require 'bucketfile_destroyer'

class BucketfilesController < ApplicationController
  respond_to :json, :js

  before_filter :redirect_to_cephlogin_if_required
  before_action :add_cephauthkeys_for_api

  def create
    if uploaded_url = CephStore.new(params, params[:bucket_name]).store_upload(params[:sobject])
      render(json: {}, status: 200)
    else
      render(json: I18n.t('bucket.object_upload_error'), status: 503)
    end
  end

  def show
    params.require(:id)
     @lister = BucketFilesLister.new(params)
      @listed_buckets = lister_has_calcuated
        if @listed_buckets.present?
          render json: {
              success: true,
              message: @listed_buckets,
              auth_keys: {
                access_key: params["access_key_id"],
                secret_key: params["secret_access_key"]
              }
            }
        else
           render json: {
              success: false,
              message: []
            }
        end
  end

  def destroy
    if destroyed = BucketFileDestroyer.new(params).perform
      #TO-DO: redirect to bucketfiles_path, if the bucket is not empty.
      redirect_to(buckets_path, status: 303,  :flash => { :success => I18n.t('cephbuckets.destroyed', :name => params[:key])}, format: 'js')
    else
      not_destroyed
    end
  rescue Nilavu::InvalidParameters
    not_destroyed
  end


  private

  def lister_has_calcuated
    if @lister
      return @lister.listed(current_cephuser.email)
    else
      false
    end
  end

  def show_listed_if_present
    @listed ||= @lister.listed
    if @listed.present?
      respond_with(@listed)
    end
  end


  def  not_listed
    fail_with('cephbuckets.unable_to_list_buckets')
  end

  def  not_uploaded
    fail_with('cephbuckets.upload_failure')
  end

  def  not_destroyed
    fail_with('cephbuckets.unable_to_destroy_bucket')
  end

  def fail_with(key)
    render_with_error(key)
  end

end
