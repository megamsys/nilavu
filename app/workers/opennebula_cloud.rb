class OpennebulaCloud
  def self.perform(options = {}, bucket_name)

    #Upload HP private key...
    #S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:private_key].original_filename, options[:private_key].read)
    #S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+File.basename(options[:private_key]), :file => options[:private_key])

    #Upload id rsa public key...
    #S3.upload(bucket_name, options[:email]+"/"+options[:id_rsa_public_key].original_filename, options[:id_rsa_public_key].read)
    #S3.upload(bucket_name, options[:email]+"/"+File.basename(options[:id_rsa_public_key]), :file => options[:id_rsa_public_key])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:opennebula_username]+"\n"+'-K='+options[:opennebula_password])

  end
end
