#Find all nodes by email
class FindNodesByEmail

  def self.perform(wparams={},tmp_email, tmp_api_key)
    begin
      @excon_res = Megam::Node.list(tmp_email, tmp_api_key)
    rescue ArgumentError => ae
      hash = {"msg" => ae.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      return re
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      hash = {"msg" => ewr.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      return re
    rescue StandardError => se
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      return re
    end
    @excon_res.data[:body]
  end

end
