class AppsItem < ActiveRecord::Base
  attr_accessible :org_id, :product_id, :my_url, :product
  
  belongs_to :organization, :foreign_key  => 'org_id'
  belongs_to :product

  #accepts_nested_attributes_for :product, :update_only => true
end
