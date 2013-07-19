class CloudBook < ActiveRecord::Base
  
  attr_accessible :users_id, :name, :platform_app, :deps_scm, :deps_war, :domain_name
  
  belongs_to :user, :foreign_key  => 'users_id'
  accepts_nested_attributes_for :user, :update_only => true
  
end
