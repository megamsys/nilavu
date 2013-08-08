#List all the predefs

class ListPredefs
  puts " -------> LIST PREDEFS "
  def self.perform(list_predefs)

   begin
    Megam::Config[:email] = list_predefs[:email]
    Megam::Config[:api_key] = list_predefs[:api_key]
    @excon_res = Megam::Predef.list
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
	@excon_res.data[:body]
  end

end
