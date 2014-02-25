class CloudBooksController < ApplicationController
  respond_to :html, :js
  include Packable
  include CloudBooksHelper
  
  ## I don't see a point in calling all the node details for an user. We should avoid it. 
  ## ie. skip FindNodesByEmail ?
  def index
    cloud_books = current_user.cloud_books.where(:book_type => 'APP').order("id DESC").all
    if cloud_books.any?
      breadcrumbs.add " Home", "#", :class => "icon icon-home", :target => "_self"      
      breadcrumbs.add "Manage Apps", cloud_books_path, :target => "_self"      

      @nodes = FindNodesByEmail.perform({},current_user.email, current_user.api_token)
      if @nodes.class == Megam::Error
        redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "API server may be down. Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/", :target => "_blank"}.", :sticky => false, :nodom_wrap => true } }
      else             
        book_names = cloud_books.map {|c| c.group_name}
        book_names = book_names.uniq
        grouped = book_names.inject({}) do |base, b| #the grouped has a short_name/Megam::Nodes collection
          group = @nodes.select{|n| n.node_name =~ /^#{b}/}
          base[b] ||= []
          base[b] << group
          base
        end        
        @launched_books = Hash[grouped.map {|key, value| [key, value.flatten.map {|vn| vn.node_name}]}]
        @launched_books_quota = @nodes.all_nodes.length 
        end           
        else    
      redirect_to new_cloud_book_path
    end
  end

  def build_request
   logger.debug "--> CloudBooks:Build_request, #{params}"
   packed_parms = packed("Meat::Defns",params)      
    @defnd_out ={}
    defnd_result =  CreateDefnRequests.send(params[:book_type].downcase.to_sym, packed_parms, force_api[:email], force_api[:api_key])    
    @defnd_out[:error] = "error" if @req.class == Megam::Error
    @defnd_out[:success] = defnd_result.some_msg[:msg] 
    respond_to do |format|
      format.js {
        respond_with(@defnd_out, :layout => !request.xhr? )
      }
    end
  end

  def get_request
    logger.debug "--> CloudBooks:get_request"   
   packed_parms = packed_h("Meat::Defns",params)   
   logger.debug "--> CloudBooks:get_request, #{params}"
   defns_result =  FindDefnById.send(params[:book_type].downcase.to_sym, packed_parms, force_api[:email], force_api[:api_key]) 
   params[:lc_apply] =  defns_result.lookup(params[:defns_id]).appdefns[:runtime_exec] unless defns_result.class == Megam::Error
    logger.debug "--> CloudBooks:get_request, #{params[:lc_apply]}"
    if params[:lc_apply]["#[start]"].present? 
         params[:lc_apply]["#[start]"] = params[:req_type]               
    end          
    packed_parms = packed("Meat::Defns",params) 
      @req_type = params[:req_type]
      @node_name = params[:node_name]  
      @appdefns_id = params[:defns_id]
      @lc_apply = params[:lc_apply]
      @book_type = params[:book_type]
   respond_to do |format|
      format.js {
        respond_with(@book_type, @lc_apply, @req_type, @node_name, @appdefns_id, :layout => !request.xhr? )
      }
   end
  end

  def send_request 
    logger.debug "--> CloudBooks:send_request"      
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
  
  def clone_build
    @node_name = "#{params[:name]}"
  end

  def clone_start
    wparams = { :node => "#{params[:clone_name]}" }
    @clone_nodes =  FindNodeByName.perform(wparams, force_api[:email],force_api[:api_key])
    logger.debug "CloudBooks:clone_start, found the node"
    if @clone_nodes.class == Megam::Error
      @res_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
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
        redirect_to cloud_books_path, :gflash => { :warning => { :value => "#{pred.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        @predef = pred.lookup(@predef_name)
      end
      
      runtime_exec = @predef.runtime_exec
       if @clone_node.node_type == "APP"
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
        @book = current_user.cloud_books.create(book_params)
        @book.save
        params = {:book_name => "#{@book.name}", :request_id => "#{res_hash[:req_id]}", :status => "created", :group_name => "#{@book.domain_name}"}
        @history = @book.cloud_books_histories.create(params)
        @history.save
        end
      end
    end
  end

  def authorize_scm
    logger.debug "CloudBooks:authorize_scm, entry"
    auth_token = request.env['omniauth.auth']['credentials']['token']
    github = Github.new oauth_token: auth_token
    git_array = github.repos.all.collect { |repo| repo.clone_url }
    @repos = git_array
    render :template => "cloud_books/new", :locals => {:repos => @repos}
  end

  def new  
    if current_user.onboarded_api
      @book =  current_user.cloud_books.build
      breadcrumbs.add " Home", "#", :class => "icon icon-home", :target => "_self"
      breadcrumbs.add "Manage Apps", cloud_books_path, :target => "_self" 
      breadcrumbs.add "Apps Framework Selection", new_cloud_book_path, :target => "_self"

    else
      redirect_to cloud_dashboards_path, :gflash => { :warning => { :value => "You need an API key to launch an app. Click Profile from the top, and generate a new API key", :sticky => false, :nodom_wrap => true } }
    end
  end

  def new_book
    breadcrumbs.add " Home", "#", :class => "icon icon-home", :target => "_self"
    breadcrumbs.add "Manage Apps", cloud_books_path, :target => "_self"
    breadcrumbs.add "Apps Framework Selection", new_cloud_book_path, :target => "_self"
    breadcrumbs.add "New", new_book_path

   if"#{params[:deps_scm]}".strip.length != 0
      @deps_scm = "#{params[:deps_scm]}"
    elsif !"#{params[:scm]}".start_with?("select")
      @deps_scm = "#{params[:scm]}"
    end
    @deps_war = "#{params[:deps_war]}" if params[:deps_war]
    @book =  current_user.cloud_books.build
    @predef_cloud = ListPredefClouds.perform(force_api[:email], force_api[:api_key])    
    if @predef_cloud.class == Megam::Error 
      redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{@predef_cloud.some_msg[:msg]}--#{@ssh_keys.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      @predef_name = params[:predef_name]
      predef_options = {:predef_name => @predef_name}
      pred = FindPredefsByName.perform(predef_options,force_api[:email],force_api[:api_key])    
      if pred.class == Megam::Error
        redirect_to new_cloud_book_path, :gflash => { :warning => { :value => "#{pred.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        @predef = pred.lookup(@predef_name)
        @domain_name = ".megam.co"
        @no_of_instances=params[:no_of_instances]
      end
    end
  end

  def create
    logger.debug ">>> Parms #{params}"
    logger.debug ">>> Parms data #{params[:data]}"
    #FORM DATA FROM PARAMS
    data={:book_name => params[:cloud_book][:appname], :book_type => params[:cloud_book][:book_type] , :predef_cloud_name => params[:cloud_book][:predef_cloud_name], :provider => params[:predef][:provider], :repo => 'default_chef', :provider_role => params[:predef][:provider_role], :domain_name => params[:cloud_book][:domain_name], :no_of_instances => params[:no_of_instances], :predef_name => params[:predef][:name], :deps_scm => params['deps_scm'], :deps_war => "#{params['deps_war']}", :timetokill => "#{params['timetokill']}", :metered => "#{params['monitoring']}", :logging => "#{params['logging']}", :runtime_exec => "#{params['runtime_exec']}"}
   if params[:cloud_book][:book_type] == "BOLT"
     data['user_name'] = params[:user_name]
     data['password'] = params[:password]
     data['store_db_name'] = params[:store_db_name]
     data['url'] = params[:url]
    end
    options = {:data => data, :group => "server", :action => "create" }
    node_hash=MakeNode.perform(options, force_api[:email], force_api[:api_key]) 
    if node_hash.class == Megam::Error
      @res_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@res_msg, :layout => !request.xhr? )
        }
      end
    else
      wparams = {:node => node_hash }
      @node = CreateNodes.perform(wparams,force_api[:email], force_api[:api_key])     
      if @node.class == Megam::Error
        @res_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
        respond_to do |format|
          format.js {
            respond_with(@res_msg, :layout => !request.xhr? )
          }
        end
      else
        @node.each do |node|       
        res = node.some_msg[:msg][node.some_msg[:msg].index("{")..node.some_msg[:msg].index("}")]       
        res_hash = eval(res)                  
        book_params={:name=> "#{res_hash[:node_name]}", :domain_name=> "#{params[:cloud_book]['domain_name']}", :predef_cloud_name => "#{params[:cloud_book]['predef_cloud_name']}", :predef_name=> "#{params[:cloud_book]['predef_name']}", :book_type=> "#{params[:cloud_book]['book_type']}", :group_name => "#{params[:cloud_book]['appname']}", :cloud_name => "#{node_hash["command"]["compute"]["cctype"]}"}                  
        @book = current_user.cloud_books.create(book_params)
        @book.save
        params = {:book_name => "#{@book.name}", :request_id => "#{res_hash[:req_id]}", :status => "created", :group_name => "#{@book.domain_name}"}
        @history = @book.cloud_books_histories.create(params)
        @history.save
        dash(@book)
        end  
      end
    end
  end

  def dash(book)
    #@dashboard=@user.dashboards.create(:name=> first_name)
    # Move the widgets creation to widgets model and use mass insert
    #inserts = []
    # TIMES.times do
    #inserts.push "(3.0, '2009-01-23 20:21:13', 2, 1)"
    # end
    # sql = "INSERT INTO widgets (`name`, `datapoints`, 'source`, `widget_type`) VALUES #{inserts.join(", ")}"
    ##
    book_source = Rails.configuration.metric_source
    @widget=@book.widgets.create(:name=>"graph", :kind=>"datapoints", :source=>book_source, :widget_type=>"pernode", :range=>"hour", :targets => ["cpu_system"])
  
    #TODO_TOM
    @widget=@book.widgets.create(:name=>"networks", :kind=>"networks_datapoints", :source=>book_source, :widget_type=>"pernode", :range=>"hour", :targets => ["pkts_out"])
    #@widget=@book.widgets.create(:name=>"totalbooks", :kind=>"totalbooks", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")
    #@widget=@book.widgets.create(:name=>"newbooks", :kind=>"newbooks", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")
    #@widget=@dashboard.widgets.create(:name=>"requests", :kind=>"requests", :source=>book_source, :widget_type=>"pernode")
    #@widget=@dashboard.widgets.create(:name=>"uptime", :kind=>"uptime", :source=>book_source, :widget_type=>"pernode")
    #@widget=@book.widgets.create(:name=>"queue", :kind=>"queue", :source=>book_source, :widget_type=>"summary", :range=>"30-minutes")
    @widget=@book.widgets.create(:name=>"runningbooks", :kind=>"runningbooks", :source=>book_source, :widget_type=>"summary", :range=>"hour")
    @widget=@book.widgets.create(:name=>"cumulativeuptime", :kind=>"cumulativeuptime", :source=>book_source, :widget_type=>"summary", :range=>"hour")
    #@widget=@dashboard.widgets.create(:name=>"requestserved", :kind=>"requestserved", :source=>book_source, :widget_type=>"pernode")
    @widget=@book.widgets.create(:name=>"queuetraffic", :kind=>"queuetraffic", :source=>book_source, :widget_type=>"summary", :range=>"hour")
  #@dashboard = Dashboard.new(:name=> params[:first_name], :user_id => current_user.id)

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
      @defnrequests =  GetDefnRequestsByNode.send(params[:book_type].downcase.to_sym, wparams,force_api[:email], force_api[:api_key])
      if @defnrequests.class == Megam::Error
        @defnrequests={"results" => {"req_type" => "", "create_at" => "", "lc_apply" => "", "lc_additional" => "", "lc_when" => ""}}
      end
      @cloud_book = @node.lookup("#{params[:name]}")
      respond_to do |format|
        format.js {
          respond_with(@cloud_book, @requests, @defnrequests, :layout => !request.xhr? )
        }
      end
    end
  end

 
  def destroy    
    @book = CloudBook.find_by_name(params[:name])
    options = {:node_name => "#{params[:name]}", :group => "server", :action => "delete", :repo => 'default_chef' }
    node_hash=DeleteNode.perform(options, force_api[:email], force_api[:api_key])    
    if node_hash.class == Megam::Error
      @res_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
    else
      options = { :req => node_hash }
      @node = CreateRequests.perform(options, force_api[:email], force_api[:api_key])
      if @node.class == Megam::Error
        @res_msg="#{@node.some_msg[:msg]} Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      else      
       @book.destroy
       @book.cloud_books_histories.each do |cbh|
            cbh.destroy
          end     
       @book.widgets.each do |cbh|
            cbh.destroy
          end  
        @res_msg = "App #{params[:name]} deleted successfully"
      end
    end

    respond_to do |format|
      format.js {
        respond_with(@res_msg, :layout => !request.xhr? )
      }
    end
  end

end
