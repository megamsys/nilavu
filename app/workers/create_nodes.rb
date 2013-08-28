class CreateNodes
  #this returns a Megam::Account object
  def self.perform(new_node)
    begin
      Megam::Config[:email] = new_node[:email]
      Megam::Config[:api_key] = new_node[:api_key]
      @excon_res = Megam::Node.create(new_node[:node])
    rescue ArgumentError => ae
      puts "===========================> AE <======================================="
      hash = {"msg" => ae.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      puts "===========================> EWR <======================================="
      hash = {"msg" => ewr.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    rescue StandardError => se
      puts "===========================> SE <======================================="
      hash = {"msg" => se.message, "msg_type" => "error"}
      re = Megam::Error.from_hash(hash)
      @res = {"data" => {:body => re}}
      return @res["data"][:body]
    end
    @excon_res.data[:body]
  end
end
