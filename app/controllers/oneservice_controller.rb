class OneServiceController < ApplicationController

  respond_to :html, :js
  include Packable
  include OneappsHelper

def show
        #@app = Appscollection(params[:app_name])
        #get the selected app
end

def overview
        serviceid = params["servicekey"]
        @assembly=GetAssembly.perform(serviceid,force_api[:email],force_api[:api_key])
        #@app = Appscollection(params[:app_name])
        #get the selected app
end

def metrics
        serviceid = params["servicekey"]
        assembly=GetAssembly.perform(appid,force_api[:email],force_api[:api_key])
        if assembly.class != Megam::Error
        @appname = assembly.name + "." + assembly.components[0][0].inputs[:domain]       
        else 
        @appname = nil       
        end
      #  respond_to do |format|
    #    format.js {
     #     respond_with(@appname, :layout => !request.xhr? )
     #   }
     # end
end

def runtime
        serviceid = params["servicekey"]
        #@app = Appscollection(params[:app_name])
        #get the selected app
end

def services
        serviceid = params["servicekey"]
        #@app = Appscollection(params[:app_name])
        #get the selected app
end

  def activities
    logger.debug "--> OneApps:Activities"
    logger.debug params
    wparams = {:node => "#{params[:name]}" }
    @name = "#{params[:name]}"
    @book_type = "#{params[:book_type]}"
    @requests = GetRequestsByNode.perform(wparams,force_api[:email], force_api[:api_key])  #no error checking for GetRequestsByNode ?
    @defnrequests = GetDefnRequestsByNode.send(params[:book_type].downcase.to_sym, wparams,force_api[:email], force_api[:api_key])
    logger.debug "--> OneApps:Activities REQUESTS====> "
    logger.debug @requests.inspect

    logger.debug "--> OneApps:Activities DEFNS REQUESTS====> "
    logger.debug @defnrequests.inspect

    if @defnrequests.class == Megam::Error
      @defnrequests={"results" => {"req_type" => "", "create_at" => "", "lc_apply" => "", "lc_additional" => "", "lc_when" => ""}}
    end
  end

  def requests
    logger.debug "--> OneApps:requests"
    packed_parms = packed_h("Meat::Defns",params)
    defns_result =  FindDefnById.send(params[:book_type].downcase.to_sym, packed_parms, force_api[:email], force_api[:api_key])
    params[:lc_apply] =  defns_result.lookup(params[:defns_id]).appdefns[:runtime_exec] unless defns_result.class == Megam::Error
    if params[:lc_apply]["#[start]"].present?
      params[:lc_apply]["#[start]"] = params[:req_type]
    end
    packed_parms = packed("Meat::Defns",params)
    @defnd_out ={}
    defnd_result =  CreateDefnRequests.send(params[:book_type].downcase.to_sym, packed_parms, force_api[:email], force_api[:api_key])
    @defnd_out[:error] = "Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}." if @req.class == Megam::Error
    @defnd_out[:success] = defnd_result.some_msg[:msg]
    respond_to do |format|
      format.js {
        respond_with(@defnd_out, :layout => !request.xhr? )
      }
    end
  end

  def preclone
    @node_name = "#{params[:name]}"
  end

  def clone
    wparams = { :node => "#{params[:clone_name]}" }
    @clone_nodes =  FindNodeByName.perform(wparams, force_api[:email],force_api[:api_key])
    logger.debug "CloudBooks:clone_start, found the node"
    if @clone_nodes.class == Megam::Error
      @res_msg=ActionController::Base.helpers.link_to 'Contact Support', "http://support.megam.co/"
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    else
      @clone_node = @clone_nodes.lookup("#{params[:clone_name]}")
      node_hash = {
        "node_name" => "#{params[:new_name]}#{params[:domain_name]}",
        "node_type" => "#{@clone_node.node_type}",
        "req_type" => "#{@clone_node.request[:req_type]}",
        "noofinstances" => params[:noofinstances].to_i,
        "command" => @clone_node.request[:command],
        "predefs" => @clone_node.predefs,
        "appdefns" => {"timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => ""},
        "boltdefns" => {"username" => "", "apikey" => "", "store_name" => "", "url" => "", "prime" => "", "timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => ""},
        "appreq" => {},
        "boltreq" => {}
      }
      @predef_name = @clone_node.predefs[:name]
      predef_options = {:predef_name => @predef_name}
      pred = FindPredefsByName.perform(predef_options,force_api[:email],force_api[:api_key])
      if pred.class == Megam::Error
        redirect_to apps_path, :gflash => { :warning => { :value => "#{pred.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        @predef = pred.lookup(@predef_name)
      end

      runtime_exec = @predef.runtime_exec
      if @clone_node.node_type == "SERVICE"
        if @clone_node.predefs[:scm].length > 0
          runtime_exec = change_runtime(@clone_node.predefs[:scm], @predef.runtime_exec)
        end
        if @clone_node.predefs[:war].length > 0
          runtime_exec = change_runtime(@clone_node.predefs[:war], @predef.runtime_exec)
        end
        #node_hash["appdefns"] = {"timetokill" => "#{data[:timetokill]}", "metered" => "#{data[:metered]}", "logging" => "#{data[:logging]}", "runtime_exec" => "#{data[:runtime_exec]}"}
        node_hash["appdefns"] = {"timetokill" => "", "metered" => "", "logging" => "", "runtime_exec" => "#{runtime_exec}"}
      end
      if @clone_node.node_type == "BOLT"
        #node_hash["boltdefns"] = {"username" => "#{data['user_name']}", "apikey" => "#{data['password']}", "store_name" => "#{data['store_name']}", "url" => "#{data['url']}", "prime" => "#{data['prime']}", "timetokill" => "#{data['timetokill']}", "metered" => "#{data['monitoring']}", "logging" => "#{data['logging']}", "runtime_exec" => "#{data['runtime_exec']}" }
      end



      wparams = {:node => node_hash }
      @node = CreateNodes.perform(wparams,force_api[:email], force_api[:api_key])
      if @node.class == Megam::Error
        @res_msg="#{node_hash.some_msg[:msg]} Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, :layout => !request.xhr? )
          }
        end
      else
        @node.each do |node|
          res = node.some_msg[:msg][node.some_msg[:msg].index("{")..node.some_msg[:msg].index("}")]
          res_hash = eval(res)
          book_params={:name=> "#{res_hash[:node_name]}", :domain_name=> "#{params[:domain_name]}", :predef_cloud_name => "default", :predef_name=> "#{@clone_node.predefs[:name]}", :book_type=> "#{@clone_node.node_type}", :group_name => "#{params[:new_name]}"}
          @book = current_user.apps.create(book_params)
          @book.save
          params = {:book_name => "#{@book.name}", :request_id => "#{res_hash[:req_id]}", :status => "created", :group_name => "#{@book.domain_name}"}
          @history = @book.apps_histories.create(params)
          @history.save
        end
      end
    end
  end
end
