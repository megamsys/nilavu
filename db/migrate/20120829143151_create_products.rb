class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :url
      t.string :image_url
      t.string :category
	t.string :identity
	t.boolean :app_bootstrap, default: true
	t.boolean :app_provisioning
     
    end
  end
  
  def self.down
   drop_table :products
end
end
