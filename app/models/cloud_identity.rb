class CloudIdentity < ActiveRecord::Base
  attr_accessible :org_id, :url, :status, :account_name, :cloud_app_url, :launch_time, :apps_item_attributes
  belongs_to :user, :foreign_key  => 'users_id'

	has_many :apps_items, :foreign_key  => 'cloud_identity_id'
  accepts_nested_attributes_for :apps_items, :update_only => true


validate :acc_name
  
  def acc_name
    @name = self.name.gsub(/[^0-9A-Za-z]/, '')
    @name = @name.gsub(" ", "")
    if @name.length > 10
    self.account_name = @name.slice(0,10)
    else
    self.account_name = @name
    end
  end

end
