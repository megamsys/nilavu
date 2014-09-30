class AmazonCloud
  def self.perform(options = {}, bucket_name)

if Rails.configuration.storage_type == "s3"
    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:aws_access_key]+"\n"+'-K='+options[:aws_secret_key])

else
    key_hash = {"-A" => "#{options[:aws_access_key]}", "-K" => "#{options[:aws_secret_key]}"}     #Riak changes
        MegamRiak.upload(bucket_name, options[:email]+"_"+options[:name], key_hash.to_json, "application/json")
end


  end
end
