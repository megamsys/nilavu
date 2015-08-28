class BaseFascade

  attr_reader :swallow_404

  class MegamAPIError < StandardError; end
  class APIConnectFailure <  MegamAPIError; end
  class UnsupportedAPI < MegamAPIError; end
  class APIInvocationFailure < MegamAPIError; end
  class MissingAPIArgsError < MegamAPIError; end
  class AuthenticationFailure < MegamAPIError; end
  class SSHKeyProcessingFailure < MegamAPIError; end

  JLAZ_PREFIX       = "Megam::".freeze
  ACCOUNT           = 'Account'.freeze
  ASSEMBLIES        = 'Assemblies'.freeze
  ASSEMBLY          = 'Assembly'.freeze
  BALANCES          = 'Balances'.freeze
  BILLINGHISTORIES  = "Billinghistories".freeze
  CATREQUESTS       = "CatRequests".freeze
  COMPONENTS        = 'Components'.freeze
  CREDITHISTORIES   = "Credithistories".freeze
  ORGANIZATION      = 'Organizations'.freeze
  PROMOS            = 'Promos'.freeze
  DISCOUNTS         = "Discounts".freeze

  MARKETPLACES      = "MarketPlace".freeze
  REQUESTS          = "Request".freeze
  SSHKEYS           = "SshKey".freeze


  CREATE            = 'create'.freeze
  SHOW              = 'show'.freeze
  LIST              = 'list'.freeze
  UPDATE            = 'update'.freeze


  def initialize(skip_gateway_error = false)
   @swallow_404 = skip_gateway_error
   Rails.logger.debug "--> #{@swallow_404}"
  end


# Returns true if the HTTP session has been started.
#This is a friendly ping to know gateway and riak is running
#probably move it to an api call /ping in the future.
  def ping?
    begin
#      open("http://#{Ind.http_api}:9000")
#      open("http://#{Ind.storage}:8098")
    rescue Exception => se
      raise se
    end
  end

  def api_request(jparams, jlaz, jmethod, passthru = false)
    jlaz = JLAZ_PREFIX + jlaz
    Rails.logger.debug "\033[01;35mFASCADE #{jlaz}#{jmethod} \33[0;34m"
    if !passthru
      raise MissingAPIArgsError, ":email and :api_key required." unless jparams.has_key?(:email && :api_key)
    end

    Rails.logger.debug("START #{jlaz}.#{jmethod}")
    begin
      jparams.each do |name, value|
        Rails.logger.debug("> #{name}: #{value}")
      end
      Rails.logger.debug("\033[01;35mRUN_NOW #{jlaz}.#{jmethod} \33[0;34m")
      return run_now(jlaz, jmethod, jparams).data
    rescue APIConnectFailure => ace
      raise APIInvocationFailure, "Gateway can't be reached. Eehaw !\n#{ace.message}"
    rescue ArgumentError => ae
      raise APIInvocationFailure, "Arguments missing. ! \n#{ae.message}"
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      raise APIInvocationFailure, "Gateway error. !\n#{ewr.message}" unless swallow_404
    rescue StandardError => se
      raise APIInvocationFailure, "(o_o) Jee..I couldn't figure out.\n#{se.message}"
    end
  end

  private


  # a private helper that runs the actual method in the api by calling jlaz.jmethod  using ruby metaprogramming

  def run_now(swallow_exception = false, jlaz, jmethod, jparams)
    Megam::Log.level(Rails.configuration.log_level)
    api_jlaz = jlaz.constantize
    unless api_jlaz.respond_to?(jmethod)
      Rails.logger.debug "Unsupported api #{jlaz}.#{jmethod}, try adding before you can use it."
      raise  UnsupportedAPI, "#{jlaz}.#{jmethod}, try adding before you can use it."
    end
    return api_jlaz.send(jmethod, jparams)
  end

end
