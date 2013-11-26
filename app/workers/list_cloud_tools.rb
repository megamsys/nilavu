#List all the predefs
class ListCloudTools
  def self.perform(list_cloudtools)
    begin
      puts "perform1"
      Megam::Config[:email] = list_cloudtools[:email]
      Megam::Config[:api_key] = list_cloudtools[:api_key]
      @excon_res = Megam::CloudTool.list
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
    puts "perform2"    
    @excon_res.data[:body]
  end
end
