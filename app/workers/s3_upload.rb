class S3Upload
  puts "----worker entry"
  def self.perform(options = {})

    #Upload AWS private key...
    s3_object_file_upload(options[:email]+"/"+options[:name]+"/"+File.basename(options[:aws_private_key]), :file => options[:aws_private_key])

    #Upload id rsa public key...
    s3_object_file_upload(options[:email]+"/"+File.basename(options[:id_rsa_public_key]), :file => options[:id_rsa_public_key])

    #Create and Upload type file ...
    s3_object_file_upload(options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    s3_object_file_upload(options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:aws_access_key]+"\n"+'-K='+options[:aws_secret_key])

  end

  def self.s3_object_file_upload(filename, data)
    bucket = s3_bucket
    # Grab a reference to an object in the bucket with the name we require
    object = bucket.objects[filename]
    # Write a local file to the aforementioned object on S3
    object.write(data)
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
