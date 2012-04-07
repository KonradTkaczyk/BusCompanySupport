class AddBusIdToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :bus_id, :integer
  end

  def self.down
    remove_column :tickets, :bus_id
  end
end
