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

class Backup < BaseFascade
  attr_reader :client # storage s3 client

  def initialize(access_key, secret_key, host)
    @client = S3::Service.new(access_key_id: "#{access_key}", secret_access_key: "#{secret_key}", host: "#{host}")
  end

  def bucket_create(bucket_name)
    bucket_array = []
    new_bucket = @client.buckets.build(bucket_name)
    new_bucket.save
  end

  def bucket_delete(bucket_name)
    bucket = @client.buckets.find("#{bucket_name}")
    bucket.destroy
  end

  def buckets_list
    bucket_array = []
    tsize = 0
    @client.buckets.each do |bkt|
      size = 0
      bkt.objects.each do |obj|
        size += obj.size.to_i
      end
      bucket_array.push(bucket_name: "#{bkt.name}", size: size.to_s(:human_size), noofobjects: bkt.objects.count)
      tsize += size
    end
    { total_buckets: @client.buckets.count, bucket_array: bucket_array, total_size: tsize }
  end

  def object_create(bucket_name, new_object)
    bucket = @client.buckets.find("#{bucket_name}")
    object = bucket.objects.build(new_object.original_filename)
    object.content = open(new_object)
    object.save
  end

  def object_download(bucket_name, object_name)
    bucket = @client.buckets.find("#{bucket_name}")
    object = bucket.objects.find("#{object_name}")
    object.content
  end

  def objects_list(bucket_name)
    bucket = @client.buckets.find("#{bucket_name}")
    bucket.objects
  end

  def object_get(bucket_name, object_name)
    bucket = @client.buckets.find("#{bucket_name}")
    object = bucket.objects.find("#{object_name}")
  end

  def object_delete(bucket_name, object_name)
    bucket = @client.buckets.find("#{bucket_name}")
    object = bucket.objects.find("#{object_name}")
    object.destroy
  end
end
