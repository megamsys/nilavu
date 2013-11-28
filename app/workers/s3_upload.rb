class S3Upload
  puts "----worker entry"
  def self.perform(filename, data)
    begin
      bucket = s3_bucket
      # Grab a reference to an object in the bucket with the name we require
      object = bucket.objects[filename]
      # Write a local file to the aforementioned object on S3
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

=begin
def s3_object_file_create(filename, data)
bucket = s3_bucket
# Grab a reference to an object in the bucket with the name we require
object = bucket.objects[filename]
# Write a local file to the aforementioned object on S3
object.write(data)
end
end
=end

  def self.s3_bucket
    bucket_name = ENV['MEGAM_AWS_S3_BUCKET']
    s3 = AWS::S3.new(
    :access_key_id => ENV['MEGAM_AWS_ACCESS_KEY'],
    :secret_access_key => ENV['MEGAM_AWS_SECRET_ID'])
    # If the bucket doesn't exist, create it
    unless s3.buckets[bucket_name].exists?
      puts "Need to make bucket #{bucket_name}.."
    s3.buckets.create(bucket_name)
    end
    s3.buckets[bucket_name]
  end

end
