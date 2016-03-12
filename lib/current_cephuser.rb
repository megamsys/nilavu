module CurrentCephUser

  def self.has_auth_cookie?(env)
    Nilavu.current_cephuser_provider.new(env).has_auth_cookie?
  end

  # can be used to pretend current user does no exist, for CSRF attacks
  def clear_current_cephuser
    @current_cephuser_provider = Nilavu.current_cephuser_provider.new({})
  end

  def log_on_cephuser(user)
    current_cephuser_provider.log_on_cephuser(user,session,cookies)
  end

  def log_off_cephuser
    current_cephuser_provider.log_off_cephuser(session,cookies)
  end


  def current_cephuser
    current_cephuser_provider.current_cephuser
  end

  private

  def current_cephuser_provider
    @current_cephuser_provider ||= Nilavu.current_cephuser_provider.new(request.env)
  end

end
