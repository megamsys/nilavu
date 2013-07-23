class SessionsController < ApplicationController
  def new

  end

  def create
    auth = social_identity
    if social_identity.nil?
      user = User.find_by_email(params[:session][:email])
      if user && user.authenticate(params[:session][:password])
        sign_in user
        flash[:success] = "Welcome #{current_user.first_name}"
        redirect_back_or users_dashboard_url, :gflash => { :success => { :value => "Welcome #{user.first_name}. Your registered email is #{user.email}, Thank you.", :sticky => false, :nodom_wrap => true } }
      else
        flash[:error] = 'Invalid username and password combination'
        render 'new'
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
    # Find an identity here
    @identity = Identity.find_from_omniauth(auth)
    if @identity.nil?
      user_identity = User.find_by_email(social_identity["info"]["email"])
      if user_identity
	@identity = user_identity.identities.create_from_omniauth(auth)
      else
	@identity = Identity.create_from_omniauth(auth)
      end
    else
      @user = User.find_by_id(@identity.users_id)
      logger.debug "Hai #{@user.inspect} oi"
      if(@user.present?)
        logger.debug "Found user with id #{@identity.users_id}"
   	sign_in @identity.user
      #@identity.user = @user
   	 #break line if true 
#redirect_back_or users_dashboard_url, :gflash => { :success => { :value => "Welcome #{@user.first_name}. Your registered email is #{@user.email}, Thank you.", :sticky => false, :nodom_wrap => true } }
      else
        #raise "Invalid user. Oops this might be a system error ! Inform the administrator."
        id_user = Identity.find_by_uid(social_identity["uid"])
        if id_user
        fb = {:email => social_identity["info"]["email"], :first_name => social_identity["info"]["name"], :phone => social_identity["info"]["phone"], :last_name => social_identity["info"]["last_name"], :uid => social_identity["uid"]}
      redirect_to new_user_path(:user_social_identity => fb), notice: "Please finish registering"
        else
	  raise "Invalid user. Oops this might be a system error ! Inform the administrator."
	end
      end
    end

    if signed_in?
      redirect_back_or users_dashboard_url, :gflash => { :success => { :value => "Welcome #{@user.first_name}. Your registered email is #{@user.email}, Thank you.", :sticky => false, :nodom_wrap => true } }
=begin
      if @identity.user == current_user
        # User is signed in so they are trying to link an identity with their
        # account. But we found the identity and the user associated with it
        # is the current user. So the identity is already associated with
        # this user. So let's display an error message.
        #TO-DO: Change the redirection to the new page as required.
        redirect_to root_url, notice: "Already linked that account!"
      else
      # The identity is not associated with the current_user so lets
      # associate the identity
        @identity.user = current_user
        @user.save()
        #TO-DO: Change the redirection to the new page as required.
        redirect_to root_url, notice: "Successfully linked that account!"
      end
=end
    else
    #if @identity.user.present?
    # The identity we found had a user associated with it so let's
    # just log them in here

    #current_user = @identity.user
    #session[:user_id] = @identity.users_id
    #logger.debug "current_users email #{current_user.email} with #{current_user.id} identity user id #{@identity.users_id}"
    #TO-DO: Change the redirection to the new page as required.
    #redirect_to users_show_url, notice: "Signed in!"
    # else
    # No user associated with the identity so we need to create a new one
@id_user = User.find_by_email(social_identity["info"]["email"])
if !@id_user
	fb = {:email => social_identity["info"]["email"], :first_name => social_identity["info"]["name"], :phone => social_identity["info"]["phone"], :last_name => social_identity["info"]["last_name"], :uid => social_identity["uid"]}
      redirect_to new_user_path(:user_social_identity => fb), notice: "Please finish registering"
else
  	sign_in @id_user
	redirect_back_or users_dashboard_url, :gflash => { :success => { :value => "Welcome #{@id_user.first_name}. Your registered email is #{@id_user.email}, Thank you.", :sticky => false, :nodom_wrap => true } }
end

    #end
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
