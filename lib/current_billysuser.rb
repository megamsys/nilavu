module CurrentBillyUser

  def self.has_auth_cookie?(env)
    Nilavu.current_billy_provider.new(env).has_auth_cookie?
  end

  def self.lookup_from_env(env)
    Nilavu.current_billy_provider.new(env).current_billy
  end


  # can be used to pretend current user does no exist, for CSRF attacks
  def clear_current_user
    @current_user_provider = Nilavu.current_billy_provider.new({})
  end

  def log_on_user(user)
    current_billy_provider.log_on_user(user,session,cookies)
  end

  def log_off_user
    current_billy_provider.log_off_user(session,cookies)
  end


  def current_billyuser
    current_billy_provider.current_billyuser
  end

  private

  def current_billy_provider
    @current_billy_provider ||= Nilavu.current_billy_provider.new(request.env)
  end

end
