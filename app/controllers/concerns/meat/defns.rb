module Meat
  class Defns

    attr_accessor :id, :node_name, :req_type, :lc_apply, :lc_additional, :lc_when

    SUPPORTED_DEFNTYPES = %w[app bolt]
    SUPPORTED_REQTYPES = %w[nstart nstop nrestart nbuild nmaintain]
    def initialize(fparams = {})
      @id = fparams[:defns_id] || nil
      @node_name = fparams[:node_name] || nil
      @req_type = fparams[:req_type] || nil
      @lc_apply = fparams[:lc_apply] || nil
      @lc_additional = fparams[:lc_additional] || nil
      @lc_when = fparams[:lc_when] || nil
    end

    #lc_when: When to apply something in an application lifecycle in the cloud.
    #If apache is started then apply stuff or don't.
    #on success do additional (eg: start a cron job) etc.
    def meatball(validate=false)
      defn_hash = {}
      if validate
        raise "You must specify a node name" % @node_name unless @node_name
        raise "You must specify a valid req_type "% SUPPORTED_REQTYPES unless SUPPORTED_REQTYPES.find {|reqtype| reqtype == @req_type}
      end
      defn_hash = {
        "req_type" => "#{@req_type}",
        "node_name" => "#{@node_name}",
        "appdefns_id" => "#{@id}",
        "lc_apply" => "#{@lc_apply}",
        "lc_additional" => "#{@lc_additional}",
        "lc_when" => "#{@lc_when}"
      }

    end

    def meatball_h
      {
        :id => @id,
        :req_type => @req_type,
        :node_name => @node_name
      }
    end
  end
end