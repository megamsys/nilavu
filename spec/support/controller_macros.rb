module ControllerMacros
  def login(user)
   #user = User.where(:login => user.to_s).first if user.is_a?(Symbol)
   ##stub the accounts here.
   ##save it in session like today..
    request.session[:user] = user.id
  end

  def current_user
    ##user the same technique as sessions_helper
    #User.find(request.session[:user])
  end
end
