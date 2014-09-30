class MegamRiak
  def self.upload(bucket_name, keyname, data, type)

puts "riak upload===============> "

#params needs bucket_name, Key, Value and content type
    begin
      bucket = riak_bucket(bucket_name)

      object = bucket.get_or_new(keyname)

     object.raw_data = data
object.content_type =type
object.store

puts "riak Erors===============> "
    rescue StandardError => se
puts "riak SE===============> "
puts se
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue ResponseError => re
puts "riak rE===============> "
puts re
      hash = {"msg" => re.message, "msg_type" => "error"}
      res = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => res}}
      return @res["data"][:body]
    end
  end

  def self.riak_bucket(bucket_name)
puts "riak bucket===============> "
    client = Riak::Client.new(:nodes => [
         {:host => "#{Rails.configuration.storage_server_url}"}
    ])
       client.bucket(bucket_name) 
  end

  def self.download(bucket_name, filename)
    begin
      bucket = s3_bucket(bucket_name)
      object = bucket.objects[filename]
      
      File.open(File.basename(filename), 'wb') do |file|
        object.read do |chunk|
          file.write(chunk)
        end
      end

    #object.url_for(:read,
    #:secure => true,
    #:expires => 24*3600,  # 24 hours
    # :response_content_disposition => "attachment; filename='#{filename}'").to_s

    end
  end

end
