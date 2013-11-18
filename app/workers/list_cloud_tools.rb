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

  def self.make_command(data, group, action, user)
    begin
      options = { :email => user.email, :api_key => user.api_token }

      @predef_cloud_collection = ListPredefClouds.perform(options)
      @predef_cloud = @predef_cloud_collection.lookup("#{data[:cloud_book][:predef_cloud_name]}")
      @cloud_tools = perform(options)
	puts "================> @ CLOUD_TOOLs <==========================="
	puts @cloud_tools.inspect
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
            "identity_file" => "/home/ubuntu/.chef/#{@predef_cloud.access[:identity_file]}",
            "ssh_user" => "#{@predef_cloud.access[:ssh_user]}"
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
