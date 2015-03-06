class SessionsController < ApplicationController
  def new
  end

  def index
    logger.debug "==> Controller: sessions, Action: create, User signin"
    auth = social_identity
    if social_identity.nil?
      @user = User.new
      user = @user.find_by_email(params[:email])
      if user != nil && @user.password_decrypt(user["password"]) == params[:password]
        if params[:remember_me]
          cookies.permanent[:remember_token] = user["remember_token"]
          cookies.permanent[:email] = user["email"]
        #cookies[:remember_token] = { :value => user.remember_token, :expires => 24.weeks.from_now }
        else
          cookies.permanent[:remember_token] = user["remember_token"]
          cookies.permanent[:email] = user["email"]
        end
        sign_in user
        redirect_to main_dashboards_path, :notice => "Welcome #{user["first_name"]}."

      else
        flash[:error] = "Invalid username and password combination "
        render "new"

      end
    else
      create_social_identity(auth)
    end
  end

  #this is a demo user who can only touch anything but mutate megam.
  def demo
      @user = User.new
      user = @user.find_by_email(params[:email])
    if user != nil && @user.password_decrypt(user["password"]) == params[:password]
      sign_in user
      redirect_to main_dashboards_path, :notice => "Welcome #{user["first_name"]}."
    else
      flash[:error] = 'Invalid demo username and password combination'
      render 'new'
    end
  end

  def create
    logger.debug "==> Controller: sessions, Action: create, User signin"
    auth = social_identity
    if social_identity.nil?
 if MegamRiak.ping
      @user = User.new
      user = @user.find_by_email(params[:email])
      if user != nil && @user.password_decrypt(user["password"]) == params[:password]
        if params[:remember_me]
          cookies.permanent[:remember_token] = user["remember_token"]
          cookies.permanent[:email] = user["email"]
        #cookies[:remember_token] = { :value => user.remember_token, :expires => 24.weeks.from_now }
        else
          cookies.permanent[:remember_token] = user["remember_token"]
          cookies.permanent[:email] = user["email"]
        end
        sign_in user
        redirect_to main_dashboards_path, :notice => "Welcome #{user["first_name"]}."

      else
        flash[:error] = "Invalid username and password combination "
        render "new"

      end
else
	#redirect_to signin_path, :error => "Riak down"
        flash[:error] = "Riak down"
        render "new"
 end
    else
      create_social_identity(auth)
    end
  end

  def fb_auth
    auth = request.env['omniauth.auth']
    session[:auth] = { :uid => auth['uid'], :provider => auth['provider'], :email => auth['info']["email"], :first_name => auth['info']['name'], :phone => auth['info']['phone'], :last_name => auth['info']['last_name'] } 
    redirect_to :controller=>'sessions'
  end

  # verify if an omniauth.auth hash exists, if not consider it as a locally registered user.
  def social_identity
    #  auth = request.env['omniauth.auth']
    auth = session[:auth]
  end

  def create_social_identity(auth)
    @user = User.new
    @identity = Identity.new
    @iden = @identity.find_from_omniauth(auth)
    #Check for identity
    if @iden.nil?
      #No Megam Identity with current social identity
      user_identity = @user.find_by_email(social_identity[:email])
      if user_identity
        #If social user Already exists in megam
        if @identity.create_from_omniauth(auth, social_identity[:email])
          redirect_to_dash(user_identity)
        else
          logger.debug "==> Controller: users, Action: create, Something went wrong! User identity not saved"
          redirect_to signup_path
        end
      else
      #If social user don't exists in megam
        if @identity.create_from_omniauth(auth, social_identity[:email])
          redirect_to_signup_with_fb
        else
          logger.debug "==> Controller: users, Action: create, Something went wrong! User not saved"
          redirect_to signup_path
        end
      end
    elsif @user.find_by_email(social_identity[:email])
      #if user and identity already connected
      
      logger.debug "Found user with id #{social_identity[:email]}"
      user_identity = @user.find_by_email(social_identity[:email])
      redirect_to_dash(user_identity)
    else
    #Exception of all the above conditions
      redirect_to_signup_with_fb
    end
  end

  def redirect_to_signup_with_fb
    fb = {:email => social_identity[:email], :first_name => social_identity[:name], :phone => social_identity[:phone], :last_name => social_identity[:last_name], :uid => social_identity[:uid]}
    #  redirect_to new_user_path(:user_social_identity => fb)
    redirect_to new_user_path
  end

  def redirect_to_dash(user)
    sign_in user
    redirect_back_or main_dashboards_path, :gflash => { :success => { :value => "Welcome #{social_identity[:name]}. Your registered email is #{social_identity[:email]}, Thank you.", :sticky => false, :nodom_wrap => true } }
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
