class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.integer :org_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.boolean :admin, default: true
      t.string :password_digest
      t.string :remember_token
      t.boolean :verified_email, default: false
      t.string :verification_hash
      t.string :user_type
      t.string :api_token
      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :remember_token
    add_index :users, :org_id
  end

  def self.down
    remove_index :users, :email
    remove_index :users, :remember_token
    remove_index :users, :org_id
    drop_table :users
  end
end
