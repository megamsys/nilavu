require 'json_kvparser'

class DeployedIps
  include JsonKVParser

  def initialize(ips_array)
    @ips_array = ips_array
  end

  def publicip
    first_public = select_with_pattern(@ips_array,'public')
    return first_public.first[:value] if first_public
  end

  def privateip
    first_private = select_with_pattern(@ips_array,'private')
    return first_private.first[:value] if first_private
  end

def hostip
    first_hostip = select_with_pattern(@ips_array,'hostip')
  return first_hostip.first[:value] if first_hostip
  end

  def all
    @ips_array.map{|ip| ip[:value]}
  end

end
