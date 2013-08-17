#List all the predefs
class ListCloudTools
  puts " -------> CLOUD TOOLS"
  
  def self.perform(list_cloudtools)

    begin
      Megam::Config[:email] = list_cloudtools[:email]
      Megam::Config[:api_key] = list_cloudtools[:api_key]
      @excon_res = Megam::CloudTools.list
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
