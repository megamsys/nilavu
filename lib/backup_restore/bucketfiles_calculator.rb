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
class BucketfilesCalculator
  attr_reader :counted
  attr_reader :spaced

  def initialize(all_bucketfiles, bucket_name)
    @all_bucketfiles = all_bucketfiles
    @bucket_name = bucket_name

    ensure_we_have_counted
  end

  def listed(email)
    aggregate_space(email)
    {:usage => @counted, :spaced => @spaced, :bucket_name => @bucket_name}
  end

  ## This is stupid, we reiterate the buckets a lot. Its because the buckets.objects
  ## just return the object name.
  def usage
    @counted ||= @all_bucketfiles.map do |bucketfile|
      BucketfileUsage.new(bucketfile)
    end
  end

  def aggregate_space(email)
    if @counted.present?
      @spaced =  StorageSpace.new(@counted)
      @spaced.calculate
    end
    @spaced
  end

  def has_bucketfiles?
    @counted ? @counted.length > 0 : false
  end

  private

  def ensure_we_have_counted
    usage if @all_bucketfiles.present?
  end
end
