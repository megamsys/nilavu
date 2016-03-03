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

    set_compute

    puts "------------- before check launch"
    puts @params.inspect
    puts "--------------------------------"

    ensure_settings_are_ok

    puts "------------- after check launch"
    puts @params.inspect
    puts "--------------------------------"

    Api::Assemblies.new.create(@params.merge!(more_params))
  end

  def ensure_settings_are_ok
    [:cpu, :ram, :hdd, :assemblyname, :componentname, :provider, :ssh_key_name].each do |setting|
      raise Nilavu::InvalidParameters unless @params[setting]
    end
  end

  private

  def more_parms
    params ||={}
    [:version, :cattype, :envs].each do |action|
      params[k] = @launch_item.send("#{k}")
    end
    set_where_to(params)
    set_name(params)
    params
  end

  def set_where_to(params)
    params[:provider] = where_to
  end

  def set_name(params)
    parms[:mkp_name] = @launch_item.name
  end

  def set_compute
    @params.merge!(FavourizeItem.new(@params[:compute_setting]).to_hash)
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
