require "forwardable"

# Biller:::Builder that selects a Billy provider to use for all the
# billable activities.
class Billy::Builder

    extend Forwardable

    attr_reader :phase_name

    def initialize(phase_name)
        @implementation = nil

        @biller = SiteSettings.enabled_biller

        @phase_name = phase_name
    end

    def load_node
        events.node_load_start(node_name, config)
        Chef::Log.debug("Building node object for #{node_name}")

        @node =
        if Chef::Config[:solo_legacy_mode]
            Chef::Node.build(node_name)
        else
            Chef::Node.find_or_create(node_name)
        end
        select_implementation(node)
        implementation.finish_load_node(node)
        node
    rescue Exception => e
        events.node_load_failed(node_name, e, config)
        raise
    end

    ## Delegated Subscriber Methods ##

    ### Accessors ###

    def_delegator :implementation, :subscriber
    def_delegator :implementation, :after_subscribe
    def_delegator :implementation, :update
    def_delegator :implementation, :after_update

    ## Delegated Orderer Methods ##

    def_delegator :implementation, :order
    def_delegator :implementation, :after_order


    ## Internal Public API ##
    def implementation
        @implementation || raise(Exceptions::InvalidPolicybuilderCall, "#load_node must be called before other policy builder methods")
    end

    def select_implementation(node)
        if policyfile_set_in_config? ||
            policyfile_attribs_in_node_json? ||
            node_has_policyfile_attrs?(node) ||
            policyfile_compat_mode_config?
            @implementation = Policyfile.new(node_name, ohai_data, json_attribs, override_runlist, events)
        else
            @implementation = ExpandNodeObject.new(node_name, ohai_data, json_attribs, override_runlist, events)
        end
    end

    def config
        Chef::Config
    end

    private

    def node_has_policyfile_attrs?(node)
        node.policy_name || node.policy_group
    end

    def policyfile_attribs_in_node_json?
        json_attribs.key?("policy_name") || json_attribs.key?("policy_group")
    end

    def policyfile_set_in_config?
        config[:use_policyfile] || config[:policy_name] || config[:policy_group]
    end

end
