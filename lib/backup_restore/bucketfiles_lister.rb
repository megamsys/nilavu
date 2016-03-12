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
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
require 'bucketobjects_counter'

class BucketFilesLister

  def initialize(ceph_parms)
    @ceph_helper = CephHelper.new(ceph_parms)
    @name = ceph_params[:bucket_name]
  end

  def bucket_files
    @ceph_helper.ceph_bucket(@bucket_name).objects
  end

  def listed
    calculate.listed
  end

  private

  def calculate
    return @calculated = BucketFilesCalculator.new(bucket_files, @name) if @calculated.present?

    raise Nilavu::NotFound unless @calculated
  end

end


#def download
#    find_object.content
#end
