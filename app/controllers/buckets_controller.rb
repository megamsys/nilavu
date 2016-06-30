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

class BucketsController < ApplicationController
  respond_to :json, :js

  before_action :redirect_to_cephlogin_if_required, only: [:index, :create, :destroy, :edit]
  before_action :add_cephauthkeys_for_api, only: [:index, :create, :destroy, :edit]


  def index
     @lister = BucketsLister.new(params)

      @listed_buckets = lister_has_calcuated
        if @listed_buckets.present?
          render json: {
              success: true,
              message: @listed_buckets,
            }
        else
           render json: {
              success: false,
              message: []
            }
        end
  end


  def create
    if BucketCreator.new(params).perform
      render json: {
          success: true,
          message: I18n.t(
            'bucket.bucket_created',
          ),
        }
    else
      render json: {
          success: false,
          message: I18n.t(
            'bucket.bucket_create_error',
          ),
        }
    end
  rescue Nilavu::InvalidParameters
    render json: {
        success: false,
        message: I18n.t(
          'bucket.bucket_create_error',
        ),
      }
  end

  def show
  end

  def edit
    if uploaded_url = CephStore.new(params, params[:id]).temporary_url("example")    
      render json: {
          success: true,
          message: uploaded_url,
        }
    else
      render json: {
          success: false,
          message: I18n.t(
            'bucket.bucket_create_error',
          ),
        }
    end
  end

  def destroy
    if BucketDestroyer.new(params).perform
      redirect_to(buckets_path, :flash => { :success => I18n.t('cephbuckets.destroyed', :name => params[:id])}, format: 'js')
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

  def not_listed
    fail_with('cephbuckets.unable_to_list_buckets')
  end

  def  not_created
    fail_with('cephbuckets.unable_to_create_bucket')
  end

  def  not_destroyed
    fail_with('cephbuckets.unable_to_destroy_bucket')
  end

  def fail_with(key)
    render_with_error(key)
  end
end
