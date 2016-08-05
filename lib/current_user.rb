module CurrentUser

  def self.has_auth_cookie?(env)
    Nilavu.current_user_provider.new(env).has_auth_cookie?
  end

  def self.lookup_from_env(env)  
    Nilavu.current_user_provider.new(env).current_user
  end


  # can be used to pretend current user does no exist, for CSRF attacks
  def clear_current_user
    @current_user_provider = Nilavu.current_user_provider.new({})
  end

  def log_on_user(user)
    current_user_provider.log_on_user(user,session,cookies)
  end

  def log_off_user
    current_user_provider.log_off_user(session,cookies)
  end


  def current_user
    current_user_provider.current_user
  end

  private

  def current_user_provider
    @current_user_provider ||= Nilavu.current_user_provider.new(request.env)
  end

end
