class RemoveUsersIdToIdentities < ActiveRecord::Migration
  def up
    remove_column :identities, :users_id
      end

  def down
    add_column :identities, :users_id, :string
  end
end
