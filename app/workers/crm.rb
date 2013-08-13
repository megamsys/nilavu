class Crm  
  puts "----worker entry"
  def self.perform(json)    
    puts "----worker entry"
   begin    
     puts json
     @excon_res = Megam::Crm.create(json)
     puts "---------------->"
     puts @excon_res
   rescue ArgumentError => ae
  hash = {"msg" => ae.message, "msg_type" => "error"}
  re = Megam::Error.from_hash(hash)
  @res = {"data" => {:body => re}}
  return @res["data"][:body]
     rescue Megam::Deccanplato::Errors::ErrorWithResponse => ewr
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
