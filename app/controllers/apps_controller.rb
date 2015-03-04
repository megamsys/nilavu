class AppsController < ApplicationController
  respond_to :html, :js
  include Packable
  include AppsHelper
  ## I don't see a point in calling all the node details for an user. We should avoid it.
  ## ie. skip FindNodesByEmail ?
  include MainDashboardsHelper
  def logs

  end

  def index
    if current_user_verify
      @user_id = current_user["email"]

      @assemblies = ListAssemblies.perform(force_api[:email],force_api[:api_key])
      @service_counter = 0
      @app_counter = 0
      if @assemblies != nil
        @assemblies.each do |asm|
          if asm.class != Megam::Error
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

  def build_request
    logger.debug "--> Apps:Build_request, #{params}"
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
    logger.debug "--> Apps:get_request"
    packed_parms = packed_h("Meat::Defns",params)
    logger.debug "--> Apps:get_request, #{params}"
    defns_result =  FindDefnById.send(params[:book_type].downcase.to_sym, packed_parms, force_api[:email], force_api[:api_key])
    params[:lc_apply] =  defns_result.lookup(params[:defns_id]).appdefns[:runtime_exec] unless defns_result.class == Megam::Error
    logger.debug "--> Apps:get_request, #{params[:lc_apply]}"
    if params[:lc_apply]["#[start]"].present?
      params[:lc_apply]["#[start]"] = params[:req_type]
    end
    params[:env_sh] = defns_result.lookup(params[:defns_id]).appdefns[:env_sh] unless defns_result.class == Megam::Error
    packed_parms = packed("Meat::Defns",params)
    @req_type = params[:req_type]
    @node_name = params[:node_name]
    @appdefns_id = params[:defns_id]
    @lc_apply = params[:lc_apply]
    @book_type = params[:book_type]
    @lc_additional = params[:env_sh]
    respond_to do |format|
      format.js {
        respond_with(@book_type, @lc_apply, @req_type, @node_name, @appdefns_id, @lc_additional, :layout => !request.xhr? )
      }
    end
  end

  def authorize_scm
    logger.debug "CloudBooks:authorize_scm, entry"
    auth_token = request.env['omniauth.auth']['credentials']['token']
    github = Github.new oauth_token: auth_token
    git_array = github.repos.all.collect { |repo| repo.clone_url }
    @repos = git_array
    render :template => "apps/new", :locals => {:repos => @repos}
  end

  def github_scm
    if !current_user_verify
      #  session[:auth] = request.env['omniauth.auth']
      auth = request.env['omniauth.auth']
      session[:auth] = { :uid => auth['uid'], :provider => auth['provider'], :email => auth['info']["email"] }
      redirect_to :controller=>'sessions', :action=>'create'
    else
      session[:info] = request.env['omniauth.auth']['credentials']
    end
  end

  def authorize_assembla
    logger.debug "CloudBooks:authorize_assembla, entry"
    assembla_repos = ListAssemblaRepos.perform(request.env['omniauth.auth']['credentials']['token'])
    if assembla_repos.class == Megam::Error
      redirect_to new_app_path, :gflash => { :warning => { :value => "#{assembla_repos.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      git_array = []
      assembla_repos.each do |repo|
        git_array << "git://git.assembla.com/#{repo["wiki_name"]}.git"
      end
      @repos = git_array
      render :template => "apps/new", :locals => {:repos => @repos}
    end
  end

  def new
    if current_user["onboarded_api"]
      #@book =  current_user.apps.build
      else
      redirect_to main_dashboards_path, :gflash => { :warning => { :value => "You need an API key to launch an app. Click Profile from the top, and generate a new API key", :sticky => false, :nodom_wrap => true } }
    end
  end

  def launch
    if"#{params[:deps_scm]}".strip.length != 0
      @deps_scm = "#{params[:deps_scm]}"
    elsif !"#{params[:scm]}".start_with?("select")
      @deps_scm = "#{params[:scm]}"
    end
    @deps_war = "#{params[:deps_war]}" if params[:deps_war]
    #   @book =  current_user.apps.build
    @predef_cloud = ListPredefClouds.perform(force_api[:email], force_api[:api_key])
    if @predef_cloud.class == Megam::Error
      redirect_to new_app_path, :gflash => { :warning => { :value => "#{@predef_cloud.some_msg[:msg]}--#{@ssh_keys.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
    else
      @predef_name = params[:predef_name]
      predef_options = {:predef_name => @predef_name}
      pred = FindPredefsByName.perform(predef_options,force_api[:email],force_api[:api_key])
      if pred.class == Megam::Error
        redirect_to new_app_path, :gflash => { :warning => { :value => "#{pred.some_msg[:msg]}", :sticky => false, :nodom_wrap => true } }
      else
        @predef = pred.lookup(@predef_name)
        @domain_name = ".megam.co"
        @no_of_instances=params[:no_of_instances]
      end
    end
  end

  def create
    logger.debug ">>> Parms #{params}"
    #FORM DATA FROM PARAMS
    data={:book_name => params[:app][:appname], :book_type => params[:app][:book_type] , :predef_cloud_name => params[:app][:predef_cloud_name], :provider => params[:predef][:provider], :repo => 'default_chef', :provider_role => params[:predef][:provider_role], :domain_name => params[:app][:domain_name], :no_of_instances => params[:no_of_instances], :predef_name => params[:predef][:name], :deps_scm => params['deps_scm'], :deps_war => "#{params['deps_war']}", :timetokill => "#{params['timetokill']}", :metered => "#{params['monitoring']}", :logging => "#{params['logging']}", :runtime_exec => "#{params['runtime_exec']}", :env_sh => "#{params['env_sh']}"}
    if params[:app][:book_type] == "BOLT"
      data['user_name'] = params[:user_name]
      data['password'] = params[:password]
      data['store_db_name'] = params[:store_db_name]
      data['url'] = params[:url]
    end
    options = {:data => data, :group => "server", :action => "create" }
    node_hash=MakeNode.perform(options, force_api[:email], force_api[:api_key])
    if node_hash.class == Megam::Error
      @err_msg="Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      respond_to do |format|
        format.js {
          respond_with(@err_msg, :layout => !request.xhr? )
        }
      end
    else
      wparams = {:node => node_hash }
      @node = CreateNodes.perform(wparams,force_api[:email], force_api[:api_key])
      if @node.class == Megam::Error

        @err_msg=ActionController::Base.helpers.link_to 'Contact Support', "http://support.megam.co/"
        respond_to do |format|
          format.js {
            respond_with(@err_msg, :layout => !request.xhr? )
          }
        end
      else
        @node.each do |node|
          res = node.some_msg[:msg][node.some_msg[:msg].index("{")..node.some_msg[:msg].index("}")]
          res_hash = eval(res)
          book_params={:name=> "#{res_hash[:node_name]}", :domain_name=> "#{params[:app]['domain_name']}", :predef_cloud_name => "#{params[:app]['predef_cloud_name']}", :predef_name=> "#{params[:app]['predef_name']}", :book_type=> "#{params[:app]['book_type']}", :group_name => "#{params[:app]['appname']}", :cloud_name => "#{node_hash["command"]["compute"]["cctype"]}"}
        #       @book = current_user.apps.create(book_params)
        #    @book.save
        #     params = {:book_name => "#{@book.name}", :request_id => "#{res_hash[:req_id]}", :status => "created", :group_name => "#{@book.domain_name}"}
        #     @history = @book.apps_histories.create(params)
        #    @history.save
        #   dash(@book)
        end
      end
    end
  end

  def dash(book)
    book_source = Rails.configuration.metric_source
    book_source = "demo" unless apply_to_cloud
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
      @cloud_book = @node.lookup("#{params[:name]}")
      respond_to do |format|
        format.js {
          respond_with(@cloud_book, :layout => !request.xhr? )
        }
      end
    end
  end

  def destroy
    @book = App.find_by_name(params[:name])
    options = {:node_name => "#{params[:name]}", :group => "server", :action => "delete", :repo => 'default_chef' }
    node_hash=DeleteNode.perform(options, force_api[:email], force_api[:api_key])
    if node_hash.class == Megam::Error
      @res_msg= ActionController::Base.helpers.link_to 'Contact Support', "http://support.megam.co/"
    else
      options = { :req => node_hash }
      @node = CreateRequests.perform(options, force_api[:email], force_api[:api_key])
      if @node.class == Megam::Error
        @res_msg="#{@node.some_msg[:msg]} Please contact #{ActionController::Base.helpers.link_to 'support !.', "http://support.megam.co/"}."
      else
        @book.destroy
        @book.apps_histories.each do |cbh|
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

  #this is a prescmmanager auth
  def scm_manager_auth

  end

  #this is a post scmmanager auth return, where the repos are listed.
  def scmmanager_auth
    path = []
    res = ListRepoNames.perform(params[:scm_session][:username], params[:scm_session][:password])
    if res[:status] != "200" && res[:status] == "401"
      flash[:error] = 'Invalid username and password combination'
      render 'apps/scm_manager_auth'
    elsif res[:status] != "200" && res[:status] != "401"
      flash[:error] = res[:some_msg]
      render 'apps/scm_manager_auth'
    else
      res[:body].each do |repo|
        uri = repo.split("//")
        path << "#{uri[0]}//#{params[:scm_session][:username]}:#{params[:scm_session][:password]}@#{uri[1]}"
      end
      render :template => "apps/new", :locals => {:repos => path}
    end
  end

  def create_scm_user

  end

end
