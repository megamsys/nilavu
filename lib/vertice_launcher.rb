require 'sshkeys_creator'
class VerticeLauncher

  attr_reader :launch_item
  attr_reader :provider
  attr_reader :params

  ONE              = 'one'.freeze
  DOCKER           = 'docker'.freeze


  def initialize(launch_item)
    @launch_item = launch_item
  end

  def set_sshkey
    SSHKeysCreator.new(params).save
  end

  def launch(params)
    @params ||= params
    raise Nilavu::NotFound  unless set_sshkey

    launch_parms = build_launch_parameters

    ensure_settings_are_ok(launch_parms)

    Api::Assemblies.new.create(launch_parms)
  end

  def build_launch_parameters
    @params.merge(more_parms)
  end

  def ensure_settings_are_ok(launch_parms)
      [:cpu, :ram, :hdd, :assemblyname, :componentname, :provider, :version, :cattype].each do |setting|
        raise Nilavu::InvalidParameters unless launch_parms[setting]
      end
  end

  def launched_message
    {name: @launch_item.name, stuff: @launch_item.type, provider: @provider}
  end

  private

  def more_parms
    params ||={}
    [:cattype, :envs].each do |launch_data|
      params[launch_data] = @launch_item.send("#{launch_data}")
    end
    set_provider(params)

    set_name(params)

    set_oneclick(params)

    params.merge!(FavourizeItem.new(@params[:compute_setting]).to_hash)
  end

  def set_provider(params)
    params[:provider] = provider
  end

  def set_name(params)
    params[:mkp_name] = @launch_item.name
  end

  def set_oneclick(params)
    if @launch_item.options.any?
     params[:oneclick] = @launch_item.oneclick.first
    end
  end

  def set_token(params)
    if @launch_item.has_token?
      params[:scm_token] = @launch_item.token
    end
  end

  def ensure_provider
    where_to ||= DOCKER
  end

  def provider
    return ONE if !@launch_item.has_docker?
    ensure_provider
  end

end
