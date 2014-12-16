class GoogleCloud
  include CrossCloudsHelper
  def self.perform(options = {}, bucket_name)

if Rails.configuration.storage_type == "s3"

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:provider_value]+".json", options[:g_json])

else
        MegamRiak.upload(bucket_name, options[:email]+"_"+options[:name], options[:g_json], "application/json")
end

  end
end
