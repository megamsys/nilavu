#Show a predef by name
class FindPredefsByName

 #this returns a Megam::PredefCloud object
  def self.perform(show_predef)
  puts " -------> FIND PREDEFS BY NAME "
   begin
    Megam::Config[:email] = show_predef[:email]
    Megam::Config[:api_key] = show_predef[:api_key]
    @excon_res = Megam::Predef.show(show_predef[:predef_name])
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
	puts "TEST PREDEF ====>  "
puts @excon_res.to_yaml
puts @excon_res.inspect
puts @excon_res.class

	@excon_res.data[:body]
  end

end
