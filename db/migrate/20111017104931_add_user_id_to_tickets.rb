class AddUserIdToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :user_id, :integer
    add_index :tickets, :user_id
  end

  def self.down
    remove_column :tickets, :user_id
    remove_index :tickets, :user_id
  end
end

