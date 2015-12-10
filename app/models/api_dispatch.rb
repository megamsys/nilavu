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
    rescue Megam::API::Errors::ErrorWithResponse => ewr
      raise StandardError, "Gateway error. !\n#{ewr.message}" unless swallow_404
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
      fail CannotAuthenticateError, 'Your credentials are missing. Sign up please.' unless parms.key?(:email) && parms.key?(:api_key)
    end
    true
  end

  def up
    #Nilavu::Healthcheck.check()
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
