require 'favour_item'

class LaunchingItem


    attr_accessor :email, :api_key, :org_id
    attr_accessor :mkp_name, :version, :cattype, :flavor
    attr_accessor :assemblyname, :componentname, :domain
    attr_accessor :keypairname, :keypairoption
    attr_accessor :region
    attr_accessor :resource, :resourceunit, :storagetype
    attr_accessor :oneclick, :options, :envs
    attr_accessor :ipv6, :privnetwork
    attr_accessor :scm_name, :scmtoken, :scmowner #historical keys, not changing them.


    ONE              = 'one'.freeze
    DOCKER           = 'docker'.freeze

    def initialize(launching_params)
        [:email, :api_key, :org_id, :mkp_name, :version, :cattype,
            :assemblyname, :domain, :keypairname, :keypairoption,
            :region, :resource, :resourceunit, :storagetype,
        :oneclick, :ipv6, :privnetwork].each do |setting|
            raise Nilavu::InvalidParameters unless launching_params[setting]
            self.send("#{setting}=",launching_params[setting])
        end

        optionals(launching_params)

        ensure_unit_is_flavourized
    end

    def  componentname
        @componentname ||= /\w+/.gen.downcase
    end

    def has_docker?
        ## this has to be based on cattype.
        cattype.include? Api::Assemblies::DOCKERCONTAINER
    end

    alias name mkp_name

    # TO-DO: This can be shortened into 1 statement by  mapping as follows
    # %w(id, name, cattype, ...).map ...
    def to_h
        res =   {
            email: email,
            api_key: api_key,
            org_id: org_id,
            mkp_name: mkp_name,
            version: version,
            assemblyname: assemblyname,
            componentname: componentname,
            domain: domain,
            region: region,
            resource: resource,
            storagetype: storagetype,
            oneclick: oneclick,
            ipv6: ipv6,
            privnetwork: privnetwork,
            sshkey: keypairname,
            keypairoption: keypairoption,
            cattype: cattype,
            cpu: @flavor.cpu,
            ram: @flavor.ram,
            hdd: @flavor.hdd,
            options: options,
            envs: envs,
            provider: provider
        }
        # i am not sure if this needed, since the data will come from ember
        set_git(res)
        res
    end


    def filtered_for_ssh
        Hash[%w(email api_key org_id keypairname keypairoption).map {|x| [x.to_sym, self.send(x.to_sym)]}]
    end

    private

    def optionals(launching_params)
        [:scm_name, :scmtoken, :scmowner].each do |setting|
            self.send("#{setting}=",launching_params[setting]) unless launching_params[setting]
        end
    end

    def ensure_unit_is_flavourized
        # return NOBlahError if !@resourceunit

        @flavor ||= FavourizeItem.new(@resourceunit)
    end

    def ensure_provider
        where_to ||= DOCKER
    end

    def provider
        return ONE if !has_docker?
        ensure_provider
    end

    def set_git(params)
        params[:scm_name] = scm_name if scm_name
        params[:scmtoken] = scmtoken if scmtoken
        params[:scmowner] = scmowner if scmowner
    end
end
