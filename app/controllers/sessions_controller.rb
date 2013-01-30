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
        redirect_back_or users_dashboard_url, :gflash => { :success => { :value => "Welcome  #{user.first_name}. Your email is #{user.email} Thank you.", :sticky => false, :nodom_wrap => true } }
      else
        flash.now[:error] = 'Invalid email/password combination'
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
      @identity = Identity.create_from_omniauth(auth)
    else
      @user = User.find_by_id(@identity.users_id)
      logger.debug "Hai #{@user.inspect} oi"
      if(@user.present?)
        logger.debug "Found user with id #{@identity.users_id}"
      @identity.user = @user
      else
        raise "Invalid user. Oops this might be a system error ! Inform the administrator."
      end
    end

    if signed_in?
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
      redirect_to new_user_url, notice: "Please finish registering"
    #end
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
