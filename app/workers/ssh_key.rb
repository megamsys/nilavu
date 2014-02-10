class SshKey
  def self.perform(options = {}, bucket_name)

    #Upload ssh private key...
    #S3.upload(bucket_name, options[:email]+"/"+options[:id_rsa_public_key].original_filename, options[:id_rsa_public_key].read)
    S3.upload(bucket_name, options[:email]+"/"+options[:ssh_key_name]+".key", options[:ssh_private_key])

   
    #Upload ssh public key...
    #S3.upload(bucket_name, options[:email]+"/"+options[:id_rsa_public_key].original_filename, options[:id_rsa_public_key].read)
    S3.upload(bucket_name, options[:email]+"/"+options[:ssh_key_name]+".pub", options[:ssh_public_key])

  end 
  
  def self.upload(options = {}, bucket_name)
    
    S3.upload(bucket_name, options[:email]+"/"+options[:ssh_key_name]+".key", options[:ssh_private_key].read)
    
    S3.upload(bucket_name, options[:email]+"/"+options[:ssh_key_name]+".pub", options[:ssh_public_key].read)
    
  end
end
