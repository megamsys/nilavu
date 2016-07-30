require "auth/current_user_provider"

class Auth::DefaultCurrentUserProvider

    CURRENT_USER_KEY ||= "_NILAVU_CURRENT_USER".freeze
    API_KEY ||= "api_key".freeze
    API_KEY_ENV ||= "_NILAVU_API".freeze
    TOKEN_COOKIE ||= "_t".freeze
    EMAIL_COOKIE ||= "_e".freeze
    PATH_INFO ||= "PATH_INFO".freeze

    # do all current user initialization here
    def initialize(env)
        @env = env
        @request = Rack::Request.new(env)
    end

    # our current user, return nil if none is found
    def current_user
        return @env[CURRENT_USER_KEY] if @env.key?(CURRENT_USER_KEY)

        request = @request

        auth_token = request.cookies[TOKEN_COOKIE]
        email_token = request.cookies[EMAIL_COOKIE]

        current_user = nil

        puts "-----curruser "
        puts current_user.inspect
        puts "---- >>>"
        
        if auth_token && email_token
            current_user = User.find_by_apikey({api_key: auth_token, email: email_token})
        end

        if current_user && (current_user.suspended? || !current_user.active)
            current_user = nil
        end

        if current_user && should_update_last_seen?
            u = current_user
            Scheduler::Defer.later "Updating Last Seen" do
                u.update_last_seen!
                u.update_ip_address!(request.ip)
            end
        end

        @env[CURRENT_USER_KEY] = current_user
    end

    def log_on_user(user, session, cookies)
        if SiteSetting.permanent_session_cookie
            cookies.permanent[TOKEN_COOKIE] = { value: user.api_key, httponly: true }
            cookies.permanent[EMAIL_COOKIE] = { value: user.email, httponly: true }
        else
            cookies[TOKEN_COOKIE] = { value: user.auth_token, httponly: true }
            cookies[EMAIL_COOKIE] = { value: user.email, httponly: true }
        end
        @env[CURRENT_USER_KEY] = user
    end

    def log_off_user(session, cookies)
        cookies[TOKEN_COOKIE] = nil
        cookies[EMAIL_COOKIE] = nil
    end


    def has_auth_cookie?
        cookie = @request.cookies[TOKEN_COOKIE]
        !cookie.nil? && cookie.length == 20
    end

end
