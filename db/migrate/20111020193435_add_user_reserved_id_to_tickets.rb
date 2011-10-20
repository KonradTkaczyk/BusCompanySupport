class AddUserReservedIdToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :user_reserved_id, :integer
    add_index :tickets, :user_reserved_id
  end

  def self.down
    remove_column :tickets, :user_reserved_id
    remove_index :tickets, :user_reserved_id
  end
end

