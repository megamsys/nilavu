class CloudIdentity < ActiveRecord::Base
  attr_accessible :users_id, :url, :status, :account_name, :cloud_app_url, :launch_time, :apps_item_attributes
  belongs_to :user, :foreign_key  => 'users_id'

	has_many :apps_items, :foreign_key  => 'cloud_identity_id'
  accepts_nested_attributes_for :apps_items, :update_only => true



end
