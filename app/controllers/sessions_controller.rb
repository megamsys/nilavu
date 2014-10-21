class SessionsController < ApplicationController
  def new
  end

  #this is a demo user who can only touch anything but mutate megam.
  def demo
    user = User.find_by_email(params[:email])

    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or main_dashboards_path, :gflash => { :success => { :value => "This is a demo dry run mode. No actual launches to cloud happens. For full version, please signout and signup for a new account.", :sticky => false, :nodom_wrap => true } }
    else
      flash[:error] = 'Invalid demo username and password combination'
      render 'new'
    end
  end

  def create
    logger.debug "==> Controller: sessions, Action: create, User signin"
    auth = social_identity
    if social_identity.nil?
      user = User.find_by_email(params[:session][:email])
      if user && user.authenticate(params[:session][:password])
        if params[:remember_me]
          cookies.permanent[:remember_token] = user.remember_token
        #cookies[:remember_token] = { :value => user.remember_token, :expires => 24.weeks.from_now }
        else
          cookies[:remember_token] = user.remember_token
        end
        sign_in user

        redirect_to main_dashboards_path, :notice => "Welcome #{user.first_name}."

      else
        flash[:error] = "Invalid username and password combination"
        render "new"

      end
    else
      create_social_identity(auth)
    end
  end

  # verify if an omniauth.auth hash exists, if not consider it as a locally registered user.
  def social_identity
    auth = request.env['omniauth.auth']
  end

  def create_social_identity(auth)
    @identity = Identity.find_from_omniauth(auth)
    #Check for identity
    if @identity.nil?
      #No Megam Identity with current social identity
      user_identity = User.find_by_email(social_identity["info"]["email"])
      if user_identity
        #If social user Already exists in megam
        user_identity.identities.create_from_omniauth(auth)
        redirect_to_dash(user_identity)
      else
      #If social user don't exists in megam
        Identity.create_from_omniauth(auth)
        redirect_to_signup_with_fb
      end
    elsif User.find_by_id(@identity.users_id)
      #if user and identity already connected
      logger.debug "Found user with id #{@identity.users_id}"
      redirect_to_dash(@identity.user)
    else
    #Exception of all the above conditions
      redirect_to_signup_with_fb
    end
  end

  def redirect_to_signup_with_fb
    fb = {:email => social_identity["info"]["email"], :first_name => social_identity["info"]["name"], :phone => social_identity["info"]["phone"], :last_name => social_identity["info"]["last_name"], :uid => social_identity["uid"]}
    redirect_to new_user_path(:user_social_identity => fb), notice: "Please finish registering"
  end

  def redirect_to_dash(user)
    sign_in user
    redirect_back_or main_dashboards_path, :gflash => { :success => { :value => "Welcome #{user.first_name}. Your registered email is #{user.email}, Thank you.", :sticky => false, :nodom_wrap => true } }
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
