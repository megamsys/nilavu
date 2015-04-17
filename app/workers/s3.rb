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
class S3
  def self.upload(bucket_name, filename, data)
    begin
      bucket = s3_bucket(bucket_name)
      object = bucket.objects[filename]
      object.write(data)
    rescue StandardError => se
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue ResponseError => re
      hash = {"msg" => re.message, "msg_type" => "error"}
      res = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => res}}
      return @res["data"][:body]
    end
  end

  def self.s3_bucket(bucket_name)
    s3 = AWS::S3.new(
    :access_key_id => ENV['MEGAM_AWS_ACCESS_KEY'],
    :secret_access_key => ENV['MEGAM_AWS_SECRET_ID'])
    # If the bucket doesn't exist, create it
    unless s3.buckets[bucket_name].exists?
    s3.buckets.create(bucket_name)
    end
    s3.buckets[bucket_name]
  end

  def self.download(bucket_name, filename)
    begin
      bucket = s3_bucket(bucket_name)
      object = bucket.objects[filename]
      
      File.open(File.basename(filename), 'wb') do |file|
        object.read do |chunk|
          file.write(chunk)
        end
      end

    #object.url_for(:read,
    #:secure => true,
    #:expires => 24*3600,  # 24 hours
    # :response_content_disposition => "attachment; filename='#{filename}'").to_s

    end
  end

end
