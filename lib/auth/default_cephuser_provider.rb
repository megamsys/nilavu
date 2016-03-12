require "auth/current_cephuser_provider"

class Auth::DefaultCurrentCephUserProvider

  CURRENT_CEPHUSER_KEY ||= "_NILAVU_CURRENT_CEPHUSER".freeze
  CEPHUSERKEY_COOKIE ||= "_c".freeze

  # do all current user initialization here
  def initialize(env)
    @env = env
    @request = Rack::Request.new(env)
  end

  # our current user, return nil if none is found
  def current_cephuser
    return @request.session[CURRENT_CEPHUSER_KEY] if @request.session[CURRENT_CEPHUSER_KEY]

    current_cephuser = nil

    @env[CURRENT_CEPHUSER_KEY] = current_cephuser
  end

  def log_on_cephuser(user, session, cookies)
    @env[CURRENT_CEPHUSER_KEY] = user
    session[CURRENT_CEPHUSER_KEY] = user
    cookies[CEPHUSERKEY_COOKIE] = user
  end

  def log_off_cephuser(session, cookies)
    session.delete(CURRENT_CEPHUSER_KEY)
    session = nil
    cookies[CEPHUSERKEY_COOKIE] = nil
  end


  def has_auth_cookie?
    cookie = @request.session[CURRENT_CEPHUSER_KEY]
    !cookie.nil? && cookie.length == 20
  end

end
