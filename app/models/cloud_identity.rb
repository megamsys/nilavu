class CloudIdentity < ActiveRecord::Base
  attr_accessible :org_id, :url
  belongs_to :organization, :foreign_key  => 'org_id'
  #accepts_nested_attributes_for :organization
end
