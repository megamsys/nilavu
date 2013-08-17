#Show a predef by name
class FindCloudToolsByName
  def self.perform(show_cloudtool)
    puts " -------> FIND CLOUDTOOL BY NAME "
    begin
      Megam::Config[:email] = show_cloudtool[:email]
      Megam::Config[:api_key] = show_cloudtool[:api_key]
      @excon_res = Megam::CloudTool.show(show_cloudtool[:predef_name])
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
    puts "TEST CLOUDTOOL ====>  "
    puts @excon_res.to_yaml
    puts @excon_res.inspect
    puts @excon_res.class

    @excon_res.data[:body]
  end

end