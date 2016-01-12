class APIDispatch
  include Nilavu::MegamResource

  attr_accessor :megfunc, :megact, :parms, :passthru, :swallow_404

  JLAZ_PREFIX       = 'Megam::'.freeze
  ACCOUNT           = 'Account'.freeze
  ASSEMBLIES        = 'Assemblies'.freeze
  ASSEMBLY          = 'Assembly'.freeze
  BALANCES          = 'Balances'.freeze
  BILLEDHISTORIES   = 'Billedhistories'.freeze
  INVOICES          = 'Invoices'.freeze
  COMPONENTS        = 'Components'.freeze
  CREDITHISTORIES   = 'Credithistories'.freeze
  ORGANIZATION      = 'Organizations'.freeze
  PROMOS            = 'Promos'.freeze
  DISCOUNTS         = 'Discounts'.freeze

  MARKETPLACES      = 'MarketPlace'.freeze
  REQUESTS          = 'Request'.freeze
  SSHKEYS           = 'SshKey'.freeze
  SENSORS           = 'Sensors'.freeze

  CREATE            = 'create'.freeze
  SHOW              = 'show'.freeze
  LIST              = 'list'.freeze
  UPDATE            = 'update'.freeze
  UPGRADE           = 'upgrade'.freeze

  class  ConnectFailure < Nilavu::MegamGWError; end
  class  CannotAuthenticateError < Nilavu::MegamGWError; end

  class NoSuchResourceType < NameError
    def initialize(short_name, node)
      super "Cannot find a resource for #{short_name} "
    end
  end

  class InvalidResourceSpecification < ArgumentError; end

  #swallow 404 errors
  def initialize(ignore_404 = false)
    @swallow_404 = ignore_404
  end

  def api_request(jlaz, jmethod, jparams, passthru=false)
    begin
      set_attributes(jlaz, jmethod, jparams, passthru)
      Rails.logger.debug "\033[01;35mFASCADE #{megfunc}#{megact} \33[0;34m"
      if up && satisfied_args?(jparams, passthru)
        invoke_submit
      end
    rescue ConnectFailure => cfe
      raise cfe
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      raise StandardError, "Whew!\n#{ewr.message}" unless swallow_404
    rescue Errno::ECONNREFUSED => ere
      raise ConnectFailure, "Api server <b>@#{Ind.api}<b> is down.</br>✓ Fix: `start megamgateway` (or) contact your administrator."
    end
  end


  def meg_function(arg=nil)
    if arg != nil
      @megfunc = JLAZ_PREFIX + arg
    else
      @megfunc
    end
  end

  def meg_action(arg=nil)
    if arg != nil
      @megact = arg
    else
      @megact
    end
  end

  def parameters(arg=nil)
    if arg != nil
      @parms = arg
      @parms = @parms.merge({:host => endpoint })
    else
      @parms
    end
  end

  def passthru?(arg=false)
    if arg != nil
      @passthru = arg
    else
      @passthru
    end
  end

  private
  def set_attributes(jlaz, jmethod, parms, passthru)
    meg_function(jlaz)
    meg_action(jmethod)
    parameters(parms)
    passthru?(passthru)
  end

  def satisfied_args?(parms,passthru)
    unless passthru
      fail CannotAuthenticateError, 'Your credentials are missing. Did you signup with us ?' unless parms.key?(:email) && parms.key?(:api_key)
    end
    true
  end

  #this works but has other issues like a stored session loops etc.
  def up
    #hc = Nilavu::HealthCheck.new.tap do |h|
    #  h.check
    #end

    #hok = hc.ok?
    #fail ConnectFailure, "Api server <b>@#{Ind.api}<b> is down.</br>✓ Fix: `start megamgateway` (or) contact your administrator." unless hok
    #hok
    true
  end

  def endpoint
    Ind.api
  end

  def debug_print(jparams)
    jparams.each do |name, value|
      Rails.logger.debug("> #{name}: #{value}")
    end
  end
end
