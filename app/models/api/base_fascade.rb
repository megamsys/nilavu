class BaseFascade

    attr_reader :email
    attr_reader :api_key

    class MegamAPIError < StandardError
    class APIConnectFailure <  MegamAPIError
    class UnsupportedAPI < MegamAPIError
    class APIInvocationFailure < MegamAPIError
    class MissingAPIArgsError < MegamAPIError

    JLAZ_PREFIX = "Megam::".freeze
    ACCOUNTS    = 'Account'.freeze
    PROFILE     =  'Profile'.freeze

    CREATE      = 'create'.freeze
    LIST        = 'list'.freeze
    UPDATE      = 'update'.freeze

    def initialize(email, api_key)
        @pinged = true
        @email = email
        @api_key = api_key
    end


    # Returns true if the HTTP session has been started.
    def ping?
      @pinged = false
      @pinged
      raise APIConnectFailure, "api.megam.io is down. Eehaw !"
    end

    def api_request(jlaz, jmethod, jparams, passthru = false)
      jlaz = JLAZ_PREFIX + jlaz
      jparams[:email]   = email
      jparams[:api_key] = api_key

      raise MissingAPIArgsError, ":email and :api_key required." unless good_to_invoke(jparams, passthru)

      logger.debug("--------> Initiating #{jlaz} to #{jmethod}")
      unless ping?
          begin
            logger.debug("---- Worker Request Params Data: ----")
            jparams.each do |name, value|
              logger.debug("#{name}: #{value}")
            end
            logger.debug("---- End Worker Request Params Data ----")
            logger.debug("API #{jlaz} #{jmethod}")
            run_now(jlaz, jmethod, jparms)
            logger.debug("---- End API call ----")
          rescue ArgumentError => ae
            raise APIInvocationFailure, "Arguments missing. ! #{ae.message}"
          rescue Megam::API::Errors::ErrorWithResponse => ewr
            raise APIInvocationFailure, "api.megam.io returned an error. !#{awr.message}"
          rescue StandardError => se
            raise APIInvocationFailure, "I couldn't figure it. !#{se.message}"
          end
      else
          raise APIConnectFailure, "api.megam.io can't be reached"
      end
      logger.debug("--------> End #{jlaz} to #{jmethod}")
  end

  private

  def good_to_invoke(jparams, passthru)
    unless passthru
      return jparams[:email] && jparams[:api_key]
    end
    true
  end

  def run_now(raise_exception = false, jlaz, jmethod, jparms)
      api_jlaz = Class.new(jlaz)
      unless api_jlaz.respond_to?(jmethod)
        logger.debug "You need to add a #{jmethod} to your #{jlaz} before you can use it."
        raise  UnsupportedAPI, "api.megam.io doesn't support #{jmethod} in #{{jlaz}"
      end
      return api_jlaz.send(jmethod, jparms)
  end

end
