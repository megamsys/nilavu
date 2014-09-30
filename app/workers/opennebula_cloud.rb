class OpennebulaCloud
  def self.perform(options = {}, bucket_name)

if Rails.configuration.storage_type == "s3"
    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:opennebula_username]+"\n"+'-K='+options[:opennebula_password])
else
    key_hash = {"-A" => "#{options[:opennebula_username]}", "-K" => "#{options[:opennebula_password]}"}     #Riak changes
        MegamRiak.upload(bucket_name, options[:email]+"_"+options[:name], key_hash.to_json, "application/json")
end


  end
end
