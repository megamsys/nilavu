require "current_user"

class AuthBag
  include CurrentUser

  def self.vertice
    if  current_user
      Hash[%w(email api_key org_id).map {|x| [x, current_user[x.to_sym]]}]
    end
  end

  def self.ceph
    if  current_user
      Hash[%w(ceph_access_key ceph_secret_key).map {|x| [x, current_user[x.to_sym]]}]
    end
  end


end
