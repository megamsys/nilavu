require 'json_kvparser'

class DeployedIps
  include JsonKVParser

  def initialize(ips_array)
    @ips_array = ips_array
  end

  def publicip
    first_public = select_with_pattern(@ips_array,'public').first
    return first_public[:value] if first_public
  end

  def privateip
    first_private = select_with_pattern(@ips_array,'private')
    return first_private[:value] if first_private
  end

def hostip
    first_host = select_with_pattern(@ips_array,'host').first
  return first_host[:value] if first_host
  end

  def all
    @ips_array.map{|ip| ip[:value]}
  end

end
