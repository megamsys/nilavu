require "auth/current_user_provider"

class Auth::DefaultCurrentUserProvider

  CURRENT_USER_KEY ||= "_NILAVU_CURRENT_USER".freeze
  APIKEY_COOKIE ||= "_t".freeze
  PATH_INFO ||= "PATH_INFO".freeze

  # do all current user initialization here
  def initialize(env)
    @env = env
    @request = Rack::Request.new(env)
  end

  # our current user, return nil if none is found
  def current_user
    return @request.session[CURRENT_USER_KEY] if @request.session[CURRENT_USER_KEY]

    current_user = nil

    @env[CURRENT_USER_KEY] = current_user
  end

  def log_on_user(user, session, cookies)
    @env[CURRENT_USER_KEY] = user
    session[CURRENT_USER_KEY] = user
  end

  def log_off_user(session, cookies)
    cookies = nil
    session.delete(CURRENT_USER_KEY)
    session = nil
    #    cookies[TOKEN_COOKIE] = nil
  end


  def has_auth_cookie?
    cookie = @request.session[CURRENT_USER_KEY]
    !cookie.nil? && cookie.length == 20
  end


end
