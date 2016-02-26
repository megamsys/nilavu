
class APIDispatch
  include VerticeResource

  attr_accessor :megfunc, :megact, :parms, :passthru, :swallow_404, :verify

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


  def initialize(ignore_404 = false)
    @swallow_404 = ignore_404
  end

  def api_request(jlaz, jmethod, jparams, passthru=false )
    set_attributes(jlaz, jmethod, jparams, passthru)

    Rails.logger.debug "\033[01;35mFASCADE #{megfunc}#{megact} \33[0;34m"

    raise Nilavu::InvalidParameters if !satisfied_args?(passthru)

    invoke_submit
    #Megam::API::Errors::ErrorWithResponse => ewr
    #"Whew!\n#{ewr.message} \n " unless swallow_404
    #"Api server <b>@#{Ind.api}<b> is down.</br>✓ Fix: `start megamgateway` (or) contact your administrator."
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

  def satisfied_args?(passthru)
    unless passthru
      return !current_user.email.blank? && !current_user.api_key.blank?
    end
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
