#List all the predefs
class MakeNode
  def self.perform(make_node, tmp_email, tmp_api_key)    
    begin     
      node_hash = Megam::MakeNode.create(make_node[:data], make_node[:group], make_node[:action], tmp_email, tmp_api_key)
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
