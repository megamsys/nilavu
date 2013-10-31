#List all the predefs
class ListPredefClouds
  puts " -------> LIST PREDEF CLOUDS "
  def self.perform(list_predefclouds)
    puts " -------> LIST PREDEF CLOUDS PERFORM "
    puts list_predefclouds
    begin
      Megam::Config[:email] = list_predefclouds[:email]
      Megam::Config[:api_key] = list_predefclouds[:api_key]
      @excon_res = Megam::PredefCloud.list
      puts "=========================> @excon_res in list PREDEF CLOUD <====================="
      puts @excon_res.inspect
    rescue ArgumentError => ae
      puts "============> AE <================"
      puts ae.inspect
      puts ae.response.inspect
      hash = {"msg" => ae.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      puts "============> ERROR WITH RESPONSE <================"
      puts ewr.inspect
      puts ewr.response.inspect
      hash = {"msg" => ewr.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue StandardError => se
      puts "============> SE <================"
      puts se.inspect
      #puts se.response
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    end
    @excon_res.data[:body]
  end

end
