class CreateAccounts
  puts " -------> CREATE ACCOUNTS "
  def self.perform(new_account)
    #new_account = new_account.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    #sleep 3
   begin
    Megam::Config[:email] = new_account[:email]
    Megam::Config[:api_key] = new_account[:api_key]
     @excon_res = Megam::Account.create(new_account)
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
