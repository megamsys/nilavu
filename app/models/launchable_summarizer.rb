require_dependency 'sshkeys_finder'


module LaunchableSummarizer

    def summary(params)
        { sshs: find_sshkeys(params) }      
    end


    def find_sshkeys(params)
        @sshfinder ||= SSHKeysFinder.new(params)
        @sshfinder.sshkeys_strip
    end

end
