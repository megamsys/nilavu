class CreateConnectorOutputs < ActiveRecord::Migration
  def self.up
    create_table :connector_outputs do |t|
      t.string :connector_id
      t.string :status
      t.string :message
      t.string :output_display
      t.string :log

      t.timestamps
    end
    add_index :connector_outputs, :connector_id
  end

  def self.down
	remove_index :connector_outputs, :connector_id
	drop_table :connector_outputs
  end
end
