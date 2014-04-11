class Gogrid
  def self.perform(options = {}, bucket_name)

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/type", 'type='+options[:type])

    #Create and Upload type file ...
    S3.upload(bucket_name, options[:email]+"/"+options[:name]+"/"+options[:type], '-A='+options[:api_key]+"\n"+'-K='+options[:shared_secret])

  end
end
