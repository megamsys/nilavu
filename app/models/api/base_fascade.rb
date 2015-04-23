class BaseFascade

    attr_reader :email
    attr_reader :api_key

    class MegamConnectFailure < StandardError
    class UnsupportedMegamAPI < StandardError
    class APIExecutionFailure < StandardError

    JLAZ_PREFIX = "Megam::".freeze

    def initialize(email, api_key)
        @pinged = true
        @email = email
        @api_key = api_key
    end


    # Returns true if the HTTP session has been started.
    def ping?
      @pinged = false
      @pinged
    end

    def api_request(jlaz, jmethod, jparams)
      jlaz = JLAZ_PREFIX + jlaz
      jparams[:email]   = email
      jparams[:api_key] = api_key

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
=begin
            hash = {"msg" => ae.message, "msg_type" => "error"}
            re = Megam::Error.from_hash(hash)
            @res = {"data" => {:body => re}}
            raise return @res["data"][:body]
=end
            raise APIExecutionFailure
          rescue Megam::API::Errors::ErrorWithResponse => ewr
=begin
            hash = {"msg" => ewr.message, "msg_type" => "error"}
            re = Megam::Error.from_hash(hash)
            @res = {"data" => {:body => re}}
            raise return @res["data"][:body]
=end
            raise APIExecutionFailure
          rescue StandardError => se
=begin
            hash = {"msg" => se.message, "msg_type" => "error"}
            re = Megam::Error.from_hash(hash)
            @res = {"data" => {:body => re}}
            raise return @res["data"][:body]
=end
            raise APIExecutionFailure
          end
      else
          raise MegamConnectFailure, "api.megam.io can't be reached" if @started
      end
      logger.debug("--------> End #{jlaz} to #{jmethod}")
  end

  private

  def run_now(raise_exception = false, jlaz, jmethod, jparms)
      api_jlaz = Class.new(jlaz)
      unless api_jlaz.respond_to?(jmethod)
        logger.debug "You need to add a #{jmethod} to your #{jlaz} before you can use it."
        raise  UnsupportedMegamAPI, "api.megam.io doesn't support #{jmethod} in #{{jlaz}"
      end
      return api_jlaz.send(jmethod, jparms)
  end
end
