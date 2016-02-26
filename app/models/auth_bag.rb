require "current_user"

class AuthBag


  def self.vertice(user)
    if  user
      Hash[%w(email api_key org_id).map {|x| [x.to_sym, user.send(x.to_sym)]}]
    end
  end

  def self.ceph(user)
    if  user
      Hash[%w(ceph_access_key ceph_secret_key).map {|x| [x.to_sym, user.send(x.to_sym)]}]
    end
  end

end
