class AppsItem < ActiveRecord::Base
  attr_accessible :cloud_app_id, :my_url, :name, :url
  
  belongs_to :cloud_app, :foreign_key  => 'cloud_app_id'
end
