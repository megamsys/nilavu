class GetBoltRequestsByNode
  #this returns a Megam::Account object
  def self.perform(node)
    begin
      Megam::Config[:email] = node[:email]
      Megam::Config[:api_key] = node[:api_key]
      @excon_res = Megam::BoltRequest.list(node[:node])
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
	puts "GET BOLT REQUEST BY NAME ============================================== >  "
	puts @excon_res.inspect
	puts @excon_res.class
    @excon_res.data[:body]
  end
end
