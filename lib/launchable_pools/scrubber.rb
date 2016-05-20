class Scrubber

  def after_scrubbed(auth_options)
    raise NotImplementedError
  end

  # can be used to hook in after the authentication process
  #  to ensure records exist for the provider in the db
  #  this MUST be implemented for authenticators that do not
  #  trust email
  def after_create_output(user, auth)
    # not required
  end

  # hook used for registering omniauth middleware,
  #  without this we can not authenticate
  def register_middleware(omniauth)
    raise NotImplementedError
  end
end
