class BaseFascade
  attr_reader :email
  attr_reader :api_key
  class MegamAPIError < StandardError; end

  class APIConnectFailure <  MegamAPIError; end

  class UnsupportedAPI < MegamAPIError; end

  class APIInvocationFailure < MegamAPIError; end

  class MissingAPIArgsError < MegamAPIError; end

  JLAZ_PREFIX = "Megam::".freeze
  ACCOUNT    = 'Account'.freeze

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
    #@pinged = true
    #@pinged
    #raise APIConnectFailure, "api.megam.io is down. Eehaw !"
    false
  end

  def api_request(jparams, jlaz, jmethod, passthru = false)
   
    jlaz = JLAZ_PREFIX + jlaz
    #jparams[:email]   = email
    #jparams[:api_key] = api_key

    raise MissingAPIArgsError, ":email and :api_key required." unless good_to_invoke(jparams, passthru)

    Rails.logger.debug "--------> Initiating #{jlaz} to #{jmethod}" 
    unless ping?
      begin
        Rails.logger.debug("---- Worker Request Params Data: ----")
        jparams.each do |name, value|
          Rails.logger.debug("#{name}: #{value}")
        end
        Rails.logger.debug("---- End Worker Request Params Data ----")
        Rails.logger.debug("API #{jlaz} #{jmethod}")
      
       
        Rails.logger.debug("---- End API call ----")
         return run_now(jlaz, jmethod, jparams).data

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
    Rails.logger.debug("--------> End #{jlaz} to #{jmethod}")
  end

  private

  def good_to_invoke(jparams, passthru)
    unless passthru
      return jparams[:email] && jparams[:api_key]
    end
    true
  end

  def run_now(raise_exception = false, jlaz, jmethod, jparams)
    
    api_jlaz = jlaz.constantize
    unless api_jlaz.respond_to?(jmethod)
      logger.debug "You need to add a #{jmethod} to your #{jlaz} before you can use it."
    raise  UnsupportedAPI
    end
    return api_jlaz.send(jmethod, jparams)
  end

end
