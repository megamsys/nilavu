class CloudBook < ActiveRecord::Base
  
  attr_accessible :users_id, :predef_name, :predef_cloud_name, :deps_scm, :deps_war, :domain_name
  
  belongs_to :user, :foreign_key  => 'users_id'
  
  
end
