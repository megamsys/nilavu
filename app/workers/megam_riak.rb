class MegamRiak
  def self.upload(bucket_name, keyname, data, type)
    #params needs bucket_name, Key, Value and content type
    begin
      bucket = riak_bucket(bucket_name)
      object = bucket.get_or_new(keyname)
      object.raw_data = data
      object.content_type =type
      object.store
    rescue StandardError => se
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue ResponseError => re
      hash = {"msg" => re.message, "msg_type" => "error"}
      res = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => res}}
      return @res["data"][:body]
    end
  end

  def self.riak_bucket(bucket_name)
    client = Riak::Client.new(:nodes => [
      {:host => "#{Rails.configuration.storage_server_url}"}
   #    {:host => "167.88.40.75" }
    ])     
    client.bucket(bucket_name)
  end

  def self.download(bucket_name, filename)
    begin
      bucket = riak_bucket(bucket_name)
      object = bucket.get_or_new(filename)

      File.open(File.basename(filename), 'wb') do |file|
        #object.read do |chunk|
          file.write(object.raw_data)
        #end
      end
    end
  end
  
  def self.fetch(bucket_name, keyname)
    #params needs bucket_name, Key, Value and content type
    begin
       bucket = riak_bucket(bucket_name)
      object = bucket.get_or_new(keyname)   
      object.content_type = "application/json" 
      object.fetch
    rescue StandardError => se
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue ResponseError => re
      hash = {"msg" => re.message, "msg_type" => "error"}
      res = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => res}}
      return @res["data"][:body]
    end
  end

end
