require 'lib/json_kvparser'

class DeployedIps
  include JsonKVParser

  def initialize(ips_array)
    @ips_array = ips_array
  end

  def publicip
    first_public = @ips_array.select_with_pattern('public').first

    return first_public[:value] if first_public
  end


  def privateip
    first_private = @ips_array.select_with_pattern('private')

    return first_private[:value] if first_private
  end

  def all
    @ips_array.map{|ip| ip[:value]}
  end

end
