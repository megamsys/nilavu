#List all the predefs
class CreateCommand
  def self.perform(data, group, action, user)    
    begin     
      puts data
      options = { :email => user.email, :api_key => user.api_token }

      @predef_cloud_collection = ListPredefClouds.perform(options)
      @predef_cloud = @predef_cloud_collection.lookup("#{data[:cloud_book][:predef_cloud_name]}")     
      @cloud_tools = ListCloudTools.perform(options)      
      @tool = @cloud_tools.lookup(data[:predef][:provider])      
      @template = @tool.cloudtemplates.lookup(@predef_cloud.spec[:type_name])      
      @cloud_instruction = @template.lookup_by_instruction(group, action)      
      @ci_command = @cloud_instruction.command      
      @ci_name = @cloud_instruction.name         
      hash = {
        "systemprovider" => {
          "provider" => {
            "prov" => "#{data[:predef][:provider]}"
          }
        },
        "compute" => {
          "cctype" => "#{@predef_cloud.spec[:type_name]}",
          "cc"=> {
            "groups" => "#{@predef_cloud.spec[:groups]}",
            "image" => "#{@predef_cloud.spec[:image]}",
            "flavor" => "#{@predef_cloud.spec[:flavor]}"
          },
          "access" => {
            "ssh_key" => "#{@predef_cloud.access[:ssh_key]}",
            "identity_file" => user.email+"/"+"#{data[:cloud_book][:predef_cloud_name]}"+"/"+"#{@predef_cloud.access[:identity_file]}",
            "ssh_user" => "#{@predef_cloud.access[:ssh_user]}",
            "vault_location" => "#{@predef_cloud.access[:vault_location]}"
          }
        },
        "cloudtool" => {
          "chef" => {
            "command" => "#{@tool.cli}",
            "plugin" => "#{@template.cctype} #{@ci_command}",
            "run_list" => "'role[#{data[:predef][:provider_role]}]'",
            #"run_list" => "'role[nodejs]'",
            "name" => "#{@ci_name} #{data[:cloud_book][:name]}"
          }
        }
      }      
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
    hash
  end

end
