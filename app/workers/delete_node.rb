#List all the predefs
class DeleteNode
  def self.perform(delete_node)    
    begin     
      Megam::Config[:email] = delete_node[:email]
      Megam::Config[:api_key] = delete_node[:api_key]      
      node_hash = Megam::DeleteNode.create(delete_node[:node_name], delete_node[:group], delete_node[:action])
       puts node_hash.inspect
      
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
    puts "WORKER NODE HASH ===============> "
    puts node_hash.inspect
    node_hash
  end

end
