class CloudIdentity < ActiveRecord::Base
  attr_accessible :org_id, :url, :status, :launch_time
  belongs_to :organization, :foreign_key  => 'org_id'
end
