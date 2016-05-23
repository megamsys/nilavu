require_dependency 'sshkeys_finder'


module LaunchableIdentifier

    def identified(params)
        { sshkeys: find_sshkeys(params) }
    end


    def find_sshkeys(params)
        @sshfinder ||= SSHKeysFinder.new(params)
        @sshfinder.sshkeys_strip
    end

end
