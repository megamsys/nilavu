class AmazonCloud
  puts "----worker entry"
  def self.perform(options = {})   
    #Upload AWS private key...
      S3Upload.perform(options[:email]+"/"+options[:name]+"/"+options[:aws_private_key].original_filename, options[:aws_private_key].read)

      #Upload id rsa public key...
      S3Upload.perform(options[:email]+"/"+options[:id_rsa_public_key].original_filename, options[:id_rsa_public_key].read)

      #Create and Upload type file ...
      S3Upload.perform(options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

      #Create and Upload type file ...
      S3Upload.perform(options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:aws_access_key]+"\n"+'-K='+options[:aws_secret_key])
        
  end
end