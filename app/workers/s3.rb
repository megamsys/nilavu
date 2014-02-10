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
      bucket.object.url_for(:read,
      :secure => true,
      :expires => 24*3600,  # 24 hours
      :response_content_disposition => "attachment; filename='#{creative_file_name}'").to_s
    end
  end

end
