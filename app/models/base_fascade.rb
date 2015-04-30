class BaseFascade

  class MegamAPIError < StandardError; end
  class APIConnectFailure <  MegamAPIError; end
  class UnsupportedAPI < MegamAPIError; end
  class APIInvocationFailure < MegamAPIError; end
  class MissingAPIArgsError < MegamAPIError; end
  class AuthenticationFailure < MegamAPIError; end

  JLAZ_PREFIX  = "Megam::".freeze
  ACCOUNT      = 'Account'.freeze
  ORGANIZATION = 'Organizations'.freeze
  ASSEMBLIES   = 'Assemblies'.freeze
  ASSEMBLY     = 'Assembly'.freeze
  COMPONENTS   = 'Components'.freeze


  CREATE      = 'create'.freeze
  SHOW        = 'show'.freeze
  LIST        = 'list'.freeze
  UPDATE      = 'update'.freeze

  def initialize
  end

  # Returns true if the HTTP session has been started.

#This is a friendly ping to know gateway and riak is running
#probably move it to an api call /ping in the future.
  def ping?
    begin
#      open("http://#{Rails.configuration.api_server_url}:9000")
#      open("http://#{Rails.configuration.storage_server_url}:8098")
    rescue Exception => se
      raise se
    end
  end

  def api_request(jparams, jlaz, jmethod, passthru = false)
    jlaz = JLAZ_PREFIX + jlaz

    if !passthru
      raise MissingAPIArgsError, ":email and :api_key required." unless jparams.has_key?(:email && :api_key)
    end

    Rails.logger.debug("START #{jlaz} to #{jmethod}")
    begin
      jparams.each do |name, value|
        Rails.logger.debug("> #{name}: #{value}")
      end
      Rails.logger.debug("> RUN_NOW #{jlaz}.#{jmethod}")
      return run_now(jlaz, jmethod, jparams).data
    rescue APIConnectFailure => ace
      raise APIInvocationFailure, "Gateway can't be reached. Eehaw !\n#{ace.message}"
    rescue ArgumentError => ae
      raise APIInvocationFailure, "Arguments missing. ! \n#{ae.message}"
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      raise APIInvocationFailure, "Gateway error. !\n#{ewr.message}"
    rescue StandardError => se
      raise APIInvocationFailure, "(o_o) Jee..I couldn't figure out.\n#{se.message}"
    end
  end

  private


  # a private helper that runs the actual method in the api by calling jlaz.jmethod  using ruby metaprogramming
  def run_now(swallow_exception = false, jlaz, jmethod, jparams)
    api_jlaz = jlaz.constantize
    unless api_jlaz.respond_to?(jmethod)
      logger.debug "Unsupported api #{jlaz}.#{jmethod}, try adding before you can use it."
      raise  UnsupportedAPI, "#{jlaz}.#{jmethod}, try adding before you can use it."
    end
    puts "sending..."
    puts jmethod
    puts jparams
    return api_jlaz.send(jmethod, jparams)
  end

end
