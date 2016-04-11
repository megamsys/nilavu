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
class BucketsCalculator

  attr_reader :counted
  attr_reader :spaced

  def initialize(all_buckets)
    @all_buckets = all_buckets

    ensure_we_have_counted
  end

  def listed(email)
    @spaced ||= aggregate_space(email)
    @spaced.calculate
    {:usage => @counted || [] , :spaced => @spaced}
  end

  def usage
    @counted ||= @all_buckets.map do |bucket|
      BucketUsage.new(bucket)
    end
  end

  def aggregate_space(email)
      StorageSpace.new(@counted)
  end

  def has_buckets?
    @counted ? @counted.length > 0 : false
  end

  private

  def ensure_we_have_counted
    usage if @all_buckets.present?
  end
end
