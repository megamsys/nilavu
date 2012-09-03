class AppsItem < ActiveRecord::Base
  attr_accessible :cloud_app_id, :product_id, :my_url, :product
  
  belongs_to :cloud_app, :foreign_key  => 'cloud_app_id'
  belongs_to :product

  #accepts_nested_attributes_for :product, :update_only => true
end
