## TO-DO need to think harder and rewrite ssh/pwd support
## in 2.0 catering to vms/containers/others

class SSHKeysCreator

    attr_reader :sshkey #this is :keypairname (assembly needs this key)
    attr_reader :keypairoption, :params

    def initialize(params)
        @params = params

        @keypairoption = params[:keypairoption]
    end


    def save
        return  :keypairoption unless @keypairoption

        if !skip_new_keypair?
            Api::Sshkeys.new.create_or_import(@params)
        end
        return autoset_sshkey
    end

    private

    def skip_new_keypair?
        @keypairoption.include?(Api::Sshkeys::OLD || Api::Sshkeys::PWD)
    end

    def keypairname
        @params[:keypairname]
    end

    def autoset_sshkey
        @params[:sshkey] = keypairname
    end

end
