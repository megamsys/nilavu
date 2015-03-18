class DeletePredefCloud
  def self.perform(predefid, tmp_email, tmp_api_key)   
	puts "Delete Predef Cloud================================> "
	puts predefid
	puts tmp_email
	puts tmp_api_key
    begin
      @excon_res = Megam::PredefCloud.delete(predefid, tmp_email, tmp_api_key)
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
