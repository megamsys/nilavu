require "current_user"
require "current_cephuser"

class AuthBag


  def self.vertice(user)
    if  user
      Hash[%w(email api_key org_id).map {|x| [x.to_sym, user.send(x.to_sym)]}]
    end
  end

  def self.ceph(ceph_user)
    if  ceph_user
      Hash[%w(access_key_id secret_access_key).map {|x| [x.to_sym, ceph_user.send(x.to_sym)]}]
    end
  end

end
