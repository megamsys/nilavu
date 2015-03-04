class ListAssemblies
  def self.perform(wparams={},tmp_email, tmp_api_key)
    begin
      @excon_res = Megam::Assemblies.list(tmp_email,tmp_api_key)
      out = @excon_res.data[:body]
      temp_out = out.each do |asmblies|
        temp_aa = asmblies.assemblies.collect  do  |one_asmblies|
          if !one_asmblies.empty?
            Megam::Assembly.show(one_asmblies,tmp_email, tmp_api_key).data[:body].each do |one_asmbly|
              temp_bb = one_asmbly.components.collect do |one_comp|
                if !one_comp.empty?
                  Megam::Components.show(one_comp,tmp_email, tmp_api_key).data[:body]
                else
                  nil
                end
              end
              one_asmbly.components.replace(temp_bb)
            end
          else
            nil
          end
        end
        asmblies.assemblies.replace(temp_aa)
      end
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
    out.to_yaml
    @excon_res.data[:body].to_yaml
    temp_out
  end

end