class SshKey

  def self.perform(options = {}, bucket_name)
#riak_changes Key format ssh_key_name+accountid
#Send content type also
puts "sshkey OPTIONS ===============> "
puts options
if Rails.configuration.storage_type == "s3"
    S3.upload(bucket_name, options[:email]+"/"+options[:ssh_key_name]+".key", options[:ssh_private_key])
    S3.upload(bucket_name, options[:email]+"/"+options[:ssh_key_name]+".pub", options[:ssh_public_key])
else
   MegamRiak.upload(bucket_name, options[:email]+"_"+options[:ssh_key_name]+"_key", options[:ssh_private_key], "application/x-pem-key")

   MegamRiak.upload(bucket_name, options[:email]+"_"+options[:ssh_key_name]+"_pub", options[:ssh_public_key], "application/vnd.ms-publisher")
end
    
  end

  def self.upload(options = {}, bucket_name)
#riak_changes Key format ssh_key_name+accountid
#Send content type also
puts "sshkey OPTIONS upload===============> "
puts options
if Rails.configuration.storage_type == "s3"
    S3.upload(bucket_name, options[:email]+"/"+options[:ssh_key_name]+".key", options[:ssh_private_key].read)
    S3.upload(bucket_name, options[:email]+"/"+options[:ssh_key_name]+".pub", options[:ssh_public_key].read)
else
  MegamRiak.upload(bucket_name, options[:email]+"_"+options[:ssh_key_name]+"_key", options[:ssh_private_key].read, options[:ssh_private_key].content_type)

   MegamRiak.upload(bucket_name, options[:email]+"_"+options[:ssh_key_name]+"_pub", options[:ssh_public_key].read, options[:ssh_public_key].content_type)
end
    
  end
end
