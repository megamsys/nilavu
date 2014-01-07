class HpCloud
  def self.perform(options = {}, bucket_name)

    #Upload HP private key...
    S3Upload.perform(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:private_key].original_filename, options[:private_key].read)
    #S3Upload.perform(bucket_name, options[:email]+"/"+options[:name]+"/"+File.basename(options[:private_key]), :file => options[:private_key])

    #Upload id rsa public key...
    S3Upload.perform(bucket_name, options[:email]+"/"+options[:id_rsa_public_key].original_filename, options[:id_rsa_public_key].read)
    #S3Upload.perform(bucket_name, options[:email]+"/"+File.basename(options[:id_rsa_public_key]), :file => options[:id_rsa_public_key])

    #Create and Upload type file ...
    S3Upload.perform(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3Upload.perform(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:hp_access_key]+"\n"+'-K='+options[:hp_secret_key])

  end
end
