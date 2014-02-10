class GoogleCloud
  include CrossCloudsHelper
  def self.perform(options = {}, bucket_name)

    #Upload id rsa public key...
    #S3.upload(bucket_name, options[:email]+"/"+options[:id_rsa_public_key].original_filename, options[:id_rsa_public_key].read)
    #S3.upload(bucket_name, options[:email]+"/"+File.basename(options[:id_rsa_public_key]), :file => options[:id_rsa_public_key])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:provider_value]+".json", options[:g_json])

  end
end
