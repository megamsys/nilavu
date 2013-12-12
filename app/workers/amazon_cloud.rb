class AmazonCloud
  puts "----worker entry"
  def self.perform(options = {}, bucket_name)

    #Upload AWS private key...
    #S3Upload.perform(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:aws_private_key].original_filename, options[:aws_private_key].read)
    S3Upload.perform(bucket_name, options[:email]+"/"+options[:name]+"/"+File.basename(options[:aws_private_key]), :file => options[:aws_private_key])

    #Upload id rsa public key...
    #S3Upload.perform(bucket_name, options[:email]+"/"+options[:id_rsa_public_key].original_filename, options[:id_rsa_public_key].read)
    S3Upload.perform(bucket_name, options[:email]+"/"+File.basename(options[:id_rsa_public_key]), :file => options[:id_rsa_public_key])

    #Create and Upload type file ...
    S3Upload.perform(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3Upload.perform(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:aws_access_key]+"\n"+'-K='+options[:aws_secret_key])

  end
end