## TO-DO need to think harder and rewrite ssh in 1.5
## The code is messy.
class SSHKeysCreator

  attr_reader :keypair_name
  attr_reader :option
  attr_reader :name

  def initialize(params)
    @params = params

    @option = params[:sshoption]
  end


  def save
    @params[:ssh_keypair_name]  =  keypair_name

    return autoset_sshkey if has_old_keypair?

    if ssh = Api::Sshkeys.new.create_or_import(@params)
      @name = ssh[:name]
    end
  end

  private

  def has_old_keypair?
    @option.include?(Api::Sshkeys::USEOLD)
  end

  def keypair_name
    if has_old_keypair?
      @keypair_name, @name = @params["#{@option}_name"]
    else
      @keypair_name = @params["#{Api::Sshkeys::NEW}_name"]
    end
  end

  def autoset_sshkey
    @params[:sshkey] = keypair_name
  end

end
