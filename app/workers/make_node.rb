#List all the predefs
class MakeNode
  def self.perform(make_node)    
    begin     
        puts "WORKER NODE HASH ===============> "
        puts make_node[:data].class
      Megam::Config[:email] = make_node[:email]
      Megam::Config[:api_key] = make_node[:api_key]      
      #command_hash = Megam::MakeCommand.command_deps
      node_hash = Megam::MakeNode.create(make_node[:data], make_node[:group], make_node[:action], make_node[:email])
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
