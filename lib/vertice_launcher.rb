require 'sshkeys_creator'
class VerticeLauncher

  attr_accessor :launch_params, :ssh_params

  def initialize(launch_item)
    @launch_params = launch_item.to_h
    @ssh_params = launch_item.filtered_for_ssh
  end

  def set_sshkey
    SSHKeysCreator.new(@ssh_params).save
    @launch_params[:sshkey] = @ssh_params[:sshkey]
  end

  def launch
    raise Nilavu::NotFound  unless set_sshkey

    ensure_settings_are_ok(@launch_params)

    Api::Assemblies.new.create(@launch_params)
  end

  def ensure_settings_are_ok(lp)
      [:mkp_name, :version, :cattype, :assemblyname, :componentname, :region, :resource,
       :sshkey, :keypairoption, :provider, :cpu, :ram, :hdd].each do |setting|
        raise Nilavu::InvalidParameters unless lp[setting]
      end
  end

  def launched
    {name: @launch_params[:mkp_name], stuff: @launch_params[:cattype], provider: @launch_params[:provider]}
  end

end
