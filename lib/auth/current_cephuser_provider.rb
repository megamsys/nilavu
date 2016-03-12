module Auth; end
class Auth::CurrentCephUserProvider

  # do all current user initialization here
  def initialize(env)
    raise NotImplementedError
  end

  # our current ceph user, return nil if none is found
  def current_cephuser
    raise NotImplementedError
  end

  # log on a user and set cookies and session etc.
  def log_on_cephuser(user,session,cookies)
    raise NotImplementedError
  end

  # api has special rights return true if api was detected
  def is_api?
    raise NotImplementedError
  end

  # we may need to know very early on in the middleware if an auth token
  # exists, to optimise caching
  def has_auth_cookie?
    raise NotImplementedError
  end


  def log_off_cephuser(session, cookies)
    raise NotImplementedError
  end
end
