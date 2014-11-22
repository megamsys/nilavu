class Gogrid
  def self.perform(options = {}, bucket_name)

if Rails.configuration.storage_type == "s3"

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:api_key]+"\n"+'-K='+options[:shared_secret])
else
    key_hash = {"-A" => "#{options[:api_key]}", "-K" => "#{options[:shared_secret]}"}     #Riak changes
        MegamRiak.upload(bucket_name, options[:email]+"_"+options[:name], key_hash.to_json, "application/json")
end

  end
end
