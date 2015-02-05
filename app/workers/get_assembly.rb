class  GetAssembly
  def self.perform(assembly_id,tmp_email, tmp_api_key)
    begin
      @excon_res = Megam::Assembly.show(assembly_id,tmp_email, tmp_api_key).data[:body].each do |one_asmbly|
              temp_bb = one_asmbly.components.collect do |one_comp|
                if !one_comp.empty?
                  Megam::Components.show(one_comp,tmp_email, tmp_api_key).data[:body]
                else
                  nil
                end
              end
              one_asmbly.components.replace(temp_bb)
            end
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
