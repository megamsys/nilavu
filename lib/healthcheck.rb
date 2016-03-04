require 'net/ping'
require 'ind'

module Nilavu
  class HealthCheck
    OK = 'ok'.freeze
    NOT_OK = 'not ok'.freeze
    REACHABLE = 'reachable'.freeze
    TIMEOUT = 'timeout'.freeze
    UNREACHABLE = 'unreachable'.freeze
    ERRORING = 'erroring'.freeze
    AUTHERROR = 'authentication error'.freeze

    attr_reader :status, :megamgw, :megamceph

    def initialize
      @status = OK
      @megamgw = { :status => REACHABLE }
      @megamceph = { :status => REACHABLE }
    end

    # Do a general health check.
    def check
      megamgw_health
      #megamceph_health
      overall
    end

    # Shortcut to see if all is well
    def ok?
      @status == OK
    end

    private

    # Try to ping gw as an indicator of general health
    def megamgw_health
      megamgw_health_metric do
        @megamgw[:status] = ERRORING if !Net::Ping::HTTP.new.ping(GlobalSetting.http_api+":9000")
      end
    end

    # What is the overall system status
    def overall
      if @megamgw[:status] != REACHABLE #|| @megamceph[:status] != REACHABLE
        @status = NOT_OK
      end
    end

    def megamgw_health_metric
      yield
    rescue Errno::ETIMEDOUT
      @megamgw[:status] = TIMEOUT
    rescue Net::HTTPServerException => e
      if e.message =~ /401/
        @megamgw[:status] = AUTHERROR
      else
        @megamgw[:status] = ERRORING
      end
    end
  end
end
