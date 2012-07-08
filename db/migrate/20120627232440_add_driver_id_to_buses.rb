class AddDriverIdToBuses < ActiveRecord::Migration
  def self.up
    add_column :buses, :user_id, :integer
    add_column :buses, :user_created_id, :integer
  end

  def self.down
    remove_column :buses, :user_id
    remove_column :buses, :user_created_id
  end
end

