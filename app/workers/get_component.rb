class  GetComponent
  def self.perform(com_id,tmp_email, tmp_api_key)
    begin
      @excon_res = Megam::Components.show(com_id,tmp_email, tmp_api_key).data[:body]                
      #=end
      rescue ArgumentError => ae
      hash = {"msg" => ae.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return [@res["data"][:body]]
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      hash = {"msg" => ewr.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return [@res["data"][:body]]
    rescue StandardError => se
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return [@res["data"][:body]]
    end
    @excon_res[0]
  end

end
