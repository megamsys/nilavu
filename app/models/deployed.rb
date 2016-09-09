require 'json_kvparser'
require 'favour_item'

class Deployed
    include JsonKVParser

    attr_accessor :name, :assembly, :input, :output, :state

    attr_reader :ips

    def initialize(assembly)

        @assembly = assembly
        ensure_symbolized_of

        set_launched_name

        what_are_my_ips
    end

    def type
        Nilavu.default_categories.select { |i| i == cattype.downcase }.first
    end

    def cattype
        @assembly.tosca_type.split(".").slice(1..1).first
    end

    def logo
        @assembly.tosca_type.split('.').last + ".png"
    end

    def set_launched_name
        @name = @assembly.name + "." + set_domain
    end

    def dockerhostip
        if @assembly.tosca_type == "tosca.microservices.dockercontainer"
            return  @ips && @ips.hostip
        end
    end

    def someip
        return @ips && (@ips.privateip || @ips.publicip )
    end

    def publicip
        @ips && @ips.publicip
    end

    def has_predeployed?
        true
    end

    def status
        @assembly.status
    end

    def region
        if region_input = select_from(@input,:region)
            region_input.first[:value] if region_input.first
        end
    end


    def sshkey
        if sshkey_input = select_from(@input, :sshkey)
            sshkey_input.first[:value] if sshkey_input.first
        end
    end


    def fullsshkey
        return "0" unless sshkey
        sshkey + "_key"
    end

    def favourized
        FavourizeItem.new(memory_core_disk)
    end

    def vnc
        "http://#{someip}:4200"
    end

    def security_help
        return unless fullsshkey
        "ssh -i " + fullsshkey + " root@"+ name
    end

    def monitored_container
        "/metrics/container/?ip=#{dockerhostip}"
    end


    def monitored_machine
        "/metrics/machine/?ip=#{someip}"
    end

    def has_envs?
        envs_to_s.length > 0
    end

    def envs_to_s
        envs = ""
        envs ||= @assembly.envs.map {|en| envs << en["value"] + "\n" }
    end

    def state
      @assembly.state
    end


    # data about one topic/assembly
    # the stuff inside inputs/outputs are wrapped in individual keys
    def to_h
        {
            id: @assembly.id,
            name: name,
            resource: {
                region: region,
                flavor: favourized
            },
            cattype: cattype,
            logo: logo,
            components: @assembly.components,
            tosca_type: @assembly.tosca_type,
            inputs: input,
            outputs: output,
            envs: envs_to_s,
            state: state,
            status: {
                message: status,
                predeploying: has_predeployed?
            },
            policies: @assembly.policies,
            network: {
                publicip: publicip,
                someip: someip
            },
            machine:  {
                vnc: vnc,
                monitor:  monitored_machine,
                security_help: security_help,
                sshkey: sshkey
            },
            container: {
                host: dockerhostip,
                monitor: monitored_container
            },
            created_at: @assembly.created_at
        }
    end


    private

    def ensure_symbolized_of
        @input = ensure_symbolized(@assembly.inputs)

        @output = ensure_symbolized(@assembly.outputs)
    end

    def set_domain
        if domain_input = select_from(@input, :domain)
            domain_input.first[:value] if domain_input.first
        end
    end

    def memory_core_disk
        [ram, cpu, hdd].join(",")
    end

    def ram
        if ram_input = select_from(@input, :ram)
            ram_input.first[:value] if ram_input.first
        end
    end

    def cpu
        if cpu_input = select_from(@input, :cpu)
            cpu_input.first[:value] if cpu_input.first
        end
    end

    def hdd
        if hdd_input = select_from(@input, :hdd)
            hdd_input.first[:value] if hdd_input.first
        end
    end

    def  what_are_my_ips
        if ips_array = select_with_pattern(@output, "ip")
            @ips = DeployedIps.new(ips_array)
        end
    end

    def has_components?
        return @assembly.components[0][0].to_json unless @assembly.components.length >0
    end
end
