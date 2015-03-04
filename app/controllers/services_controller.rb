class ServicesController < ApplicationController

  respond_to :html, :js
    include MainDashboardsHelper
 def index
    if current_user_verify
      @user_id = current_user["email"]

      @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
      @service_counter = 0
      @app_counter = 0
      if @assemblies != nil
        @assemblies.each do |asm|
          if asm.class != Megam:: Error
            asm.assemblies.each do |assembly|
              if assembly != nil
                if assembly[0].class != Megam::Error
                  #@app_counter = assembly[0].components.count + @app_counter                  
                  assembly[0].components.each do |com|
                    if com != nil
                      com.each do |c|
                        com_type = c.tosca_type.split(".")
                        ctype = get_type(com_type[2])
                         if ctype == "SERVICE" 
                           @service_counter = @service_counter + 1
                        else
                                @app_counter = @app_counter + 1
                         end 
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
     
    else
      redirect_to signin_path
    end
  end



  def new
    logger.debug "Cloud Store new  ==> "
  end

  def new_store
    logger.debug "New Store init Params ==> "
    logger.debug "#{params}"

    @db_model = params[:db_model]
    @dbms = params[:dbms]
 #   @book =  current_user.apps.build
    @predef_name = params[:dbms]
    if"#{params[:deps_scm]}".strip.length != 0
      @deps_scm = "#{params[:deps_scm]}"
    elsif !"#{params[:scm]}".start_with?("select")
      @deps_scm = "#{params[:scm]}"
    end
    predef_options = { :predef_name => @predef_name}
    @predef_cloud = ListPredefClouds.perform(force_api[:email], force_api[:api_key])
    if @predef_cloud.class == Megam::Error
      redirect_to new_service_path, :gflash => { :warning => { :value => "#{@predef_cloud.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
    #if @predef_cloud.some_msg[:msg_type] != "error"
      pred = FindPredefsByName.perform(predef_options,force_api[:email],force_api[:api_key])
      if pred.class == Megam::Error
        redirect_to new_service_path, :gflash => { :warning => { :value => "#{pred.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        @predef = pred.lookup(@predef_name)
        @domain_name = ".megam.co"
        @no_of_instances=params[:no_of_instances]
      end
    end

  end

  def create
    logger.debug "Create Cloud store Params ==> "
    logger.debug "#{params}"
  end

  def show
    wparams = {:node => "#{params[:name]}" }
    #look at storing in a local session, as we are redoing it. 
    # The node json is getting heavy as well    
    @node = FindNodeByName.perform(wparams,force_api[:email],force_api[:api_key])
    logger.debug "--> CloudBooks:show, found node #{wparams[:node]}"
    if @node.class == Megam::Error
      @res_msg="We went into nirvana, finding node #{wparams[:node]}. Open up a support ticket. We'll investigate its disappearence #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    else
      @requests = GetRequestsByNode.perform(wparams,force_api[:email], force_api[:api_key])  #no error checking for GetRequestsByNode ? 
      @book_requests =  GetDefnRequestsByNode.send(params[:book_type].downcase.to_sym, wparams,force_api[:email], force_api[:api_key])
      if @book_requests.class == Megam::Error
        @book_requests={"results" => {"req_type" => "", "create_at" => "", "lc_apply" => "", "lc_additional" => "", "lc_when" => ""}}
      end
      @cloud_book = @node.lookup("#{params[:name]}")
      respond_to do |format|
        format.js {
          respond_with(@cloud_book, @requests, @book_requests, :layout => !request.xhr? )
        }
      end
    end
  end


end
