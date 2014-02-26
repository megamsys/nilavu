class App < ActiveRecord::Base
    validates :predef_name, presence: true
    validates :predef_cloud_name, presence: true
  attr_accessible :users_id, :predef_name, :name, :book_type, :predef_cloud_name, :app_defn_ids, :bolt_defn_ids, :domain_name, :apps_history_attributes, :group_name, :cloud_name
  
  belongs_to :user, :foreign_key  => 'users_id'
  
  has_many :apps_histories, :foreign_key => 'book_id'  
  accepts_nested_attributes_for :apps_histories , :update_only => true
 
 has_many :widgets, :foreign_key  => 'dashboard_id'
  accepts_nested_attributes_for :widgets, :update_only => true

end
