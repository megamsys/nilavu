class CreatePredefClouds
  puts " -------> CREATE PredefClouds "
  def self.perform(new_predef)
    #sleep 3
    puts "=============================> CREATE PREDEFCLOUDS PERFORM PARAMS <================================== "
    puts new_predef
    begin
      Megam::Config[:email] = new_account[:email]
      Megam::Config[:api_key] = new_account[:api_key]
      @excon_res = Megam::PredefClouds.create(new_predef)
      puts "=========================> @excon_res in CREATE PREDEFCLOUDS <====================="
      puts @excon_res.inspect
    rescue ArgumentError => ae
      puts "===========================> AE <======================================="
      hash = {"msg" => ae.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      puts "===========================> EWR <======================================="
      hash = {"msg" => ewr.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue StandardError => se
      puts "===========================> SE <======================================="
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    end
    @excon_res.data[:body]
  end
end
