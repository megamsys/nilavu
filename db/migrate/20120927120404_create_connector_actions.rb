class CreateConnectorActions < ActiveRecord::Migration
  def self.up
    create_table :connector_actions do |t|
	t.integer :connector_id      
	t.string :user_name
        t.string :profile_id
	t.string :first_name
	t.string :last_name
	t.string :email
	t.string :alias
	t.string :time_zone, default: "America/Los_Angeles"
	t.string :locale, default: "en_US"
	t.string :char_set_encoding, default: "UTF-8"
	t.string :language, default: "en_US"
	

      t.timestamps
    end
	add_index :connector_actions, :connector_id
  end

  def self.down
	remove_index :connector_actions, :connector_id
	drop_table :connector_actions
  end
end






