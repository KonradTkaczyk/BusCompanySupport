class AddTripAndBoughtToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :trip, :integer
    add_column :tickets, :bought, :boolean, :default => false
  end

  def self.down
    remove_column :tickets, :bought
    remove_column :tickets, :trip
  end
end

