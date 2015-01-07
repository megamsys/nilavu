#class Identity < ActiveRecord::Base
class Identity 
  def initialize()
    @email = nil
    @uid = nil
    @provider = nil
    @created_at = nil
    @updated_at = nil
  end
  
  def builder(auth, email)
    hash = {
      "email" => email,
      "uid" => auth[:uid],
      "provider" => auth[:provider],
      "created_at" => Time.zone.now,
      "updated_at" => "" 
    }

    hash.to_json
  end

  def create_from_omniauth(auth, email)
    hash = builder(auth, email)
    result = true
    res_body = MegamRiak.upload("identity", auth[:uid], hash, "application/json")
    if res_body.class == Megam::Error
    result = false
    end
    result
  end
  
  def find_from_omniauth(auth)     
  # find_by_provider_and_uid(auth['provider'], auth['uid'])
    find_by_uid(auth[:uid])
  end  
 
  def find_by_uid(uid)
  result = nil
     res = MegamRiak.fetch("identity", uid)
     if res.class != Megam::Error
        result = res.content.data
    end
    result  
  end
  
=begin  
 attr_accessible :users_id, :uid, :provider
#  belongs_to :user, :foreign_key  => 'users_id'
#  validates :provider, :uid, :presence => true
  def self.find_from_omniauth(auth)
    find_by_provider_and_uid(auth['provider'], auth['uid'])
  end

  def self.create_from_omniauth(auth, user = nil)
    self.create(:uid => auth['uid'], :provider => auth['provider'])
  end
=end
end
