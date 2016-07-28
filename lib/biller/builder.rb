require "forwardable"

# Biller:::Builder that selects a Billy provider to use for all the
# billable activities.
class Biller::Builder

    extend Forwardable

    attr_reader :processe

    def initialize(processe_name)
        @implementation = nil

        @processe = processe_name
    end

    def load_processe
        return Nilavu::NotFound unless  has_enabled_biller?

        select_implementation(SiteSettings.enabled_biller)
    end

    ## Delegated Subscriber Methods ##

    ### Accessors ###

    def_delegator :implementation, :subscribe
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

    def select_implementation(biller_name)
        @implementation = ['Biller::',biller_name,@processe.capitalize].join('').constantize
        unless @implementation
            Rails.logger.debug "No clazz Biller::#{biller_name}#{@processe.capitalize} found."
            fail Nilavu::NotFound
        end
    end

    private

    def has_enabled_biller?
        SiteSettings.enabled_biller && SiteSettings.enabled_biller.lstrip.length > 0
    end

end
