#List all the predefs

class ListPredefClouds
  puts " -------> LIST PREDEF CLOUDS "
  def self.perform(list_predefclouds)
   begin
    Megam::Config[:email] = list_predefclouds[:email]
    Megam::Config[:api_key] = list_predefclouds[:api_key]
    @excon_res = Megam::PredefCloud.list
    rescue ArgumentError => ae
	hash = {"msg" => ae.message, "msg_type" => "error"}
	re = Megam::Error.from_hash(hash)
	@res = {"data" => {:body => re}}
	return @res["data"][:body]
     rescue Megam::API::Errors::ErrorWithResponse => ewr
	hash = {"msg" => ewr.message, "msg_type" => "error"}
	re = Megam::Error.from_hash(hash)
	@res = {"data" => {:body => re}}
	return @res["data"][:body]
     rescue StandardError => se
	hash = {"msg" => se.message, "msg_type" => "error"}
	re = Megam::Error.from_hash(hash)
	@res = {"data" => {:body => re}}
	return @res["data"][:body]
   end
	puts "EXCON RES class-------------->>>>>>>>>>>>  "
	puts @excon_res.class
	puts "EXCON RES -------------->>>>>>>>>>>>  "
	puts @excon_res.inspect
	puts @excon_res.to_yaml
	@excon_res.data[:body]
  end

end
