#List all the predefs
class DeleteNode
  def self.perform(delete_node)    
    begin     
      node_hash = Megam::DeleteNode.create(delete_node[:node_name], delete_node[:group], delete_node[:action])
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
    node_hash
  end

end
