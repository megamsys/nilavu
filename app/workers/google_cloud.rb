class GoogleCloud
include CrossCloudsHelper
  puts "----worker entry"
  def self.perform(options = {})   
    
      #Upload id rsa public key...
      S3Upload.perform(options[:email]+"/"+File.basename(options[:id_rsa_public_key]), :file => options[:id_rsa_public_key])

      #Create and Upload type file ...
      S3Upload.perform(options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

      #Create and Upload type file ...
      S3Upload.perform(options[:email]+"/"+options[:name]+"/"+options[:provider_value]+".json", options[:g_json])
        
  end
end