class AddAttachmentLogoToOrganizations < ActiveRecord::Migration
  def self.up
    change_table :organizations do |t|
      t.has_attached_file :logo
    end
  end

  def self.down
    drop_attached_file :organizations, :logo
  end
end
