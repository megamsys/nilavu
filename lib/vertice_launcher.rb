require 'sshkeys_creator'
class VerticeLauncher

  attr_reader :launch_item
  attr_reader :provider
  attr_reader :params

  ONE              = 'one'.freeze
  DOCKER           =  'docker'.freeze


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
    [:cpu, :ram, :hdd, :assemblyname, :componentname, :provider, :ssh_keypair_name, :version, :cattype].each do |setting|
        raise Nilavu::InvalidParameters unless launch_parms[setting]
    end
  end

  private

  def more_parms
    params ||={}
    [:cattype, :envs].each do |launch_data|
      params[launch_data] = @launch_item.send("#{launch_data}")
    end
    set_where_to(params)

    set_name(params)

    params.merge!(FavourizeItem.new(@params[:compute_setting]).to_hash)
  end

  def set_where_to(params)
    params[:provider] = where_to
  end

  def set_name(params)
    params[:mkp_name] = @launch_item.name
  end

  #    set_scmname(params)

  def ensure_where_to
    where_to ||= DOCKER
  end

  def where_to
    return ONE if !@launch_item.has_docker?
    ensure_where_to
  end

end
