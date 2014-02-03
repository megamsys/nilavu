class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|
      t.string :name
      t.string :kind
      t.string :size
      t.string :source
      t.text :targets, :default => [].to_yaml
      t.text :range
      t.integer :dashboard_id
      t.string :widget_type

      t.timestamps
    end
    add_index :widgets, :dashboard_id
  end
  
  def self.down
     remove_index :widgets, :dashboard_id
     drop_table :widgets
  end
end
