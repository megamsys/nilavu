module SessionsHelper
  def sign_in(user)
    cookies.permanent[:email] = user["email"]
    cookies.permanent[:remember_token] = user["remember_token"]
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

#  def current_user
 #   @current_user ||= User.find_by_remember_token(cookies[:remember_token], cookies[:email]) if cookies[:remember_token] && cookies[:email]
#  end

def sign_in_current_user(remember_token,email)

   @user = User.new
   res = @user.find_by_remember_token(remember_token,email) if remember_token && email
   if res != nil
     @current_user ||= res

    else
     redirect_to signin_path
    end

end

 def current_user

    @user = User.new
    res = @user.find_by_remember_token(cookies[:remember_token], cookies[:email]) if cookies[:remember_token] && cookies[:email]
    if res != nil
      @current_user ||= res

     else
      redirect_to signin_path
     end

 end

  def current_user_verify
   @user = User.new
    res = @user.find_by_remember_token(cookies[:remember_token], cookies[:email]) if cookies[:remember_token] && cookies[:email]
    if res != nil
      @current_user ||= res
      return true
     else
       return false
     end
  end



  def current_user?(user)
    user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "Please sign in."
    end
  end

  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
    cookies.delete(:email)
  end

  def redirect_back_or(default, growl_message)
    redirect_to((session[:return_to] || default), growl_message)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

   def force_api(email=nil, api_token=nil)
    # dangerous. You are setting a global variable
    Megam::Log.level(Rails.configuration.log_level)
    email ||=current_user["email"]
    api_token ||=current_user["api_token"]
    logger.debug "--> force_api as email: #{email}, #{api_token}"
    {:email => email, :api_key => api_token }
  end

end
