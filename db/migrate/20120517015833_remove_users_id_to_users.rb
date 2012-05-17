class RemoveUsersIdToUsers < ActiveRecord::Migration
  def up
    remove_column :users, :users_id
      end

  def down
    add_column :users, :users_id, :string
  end
end
