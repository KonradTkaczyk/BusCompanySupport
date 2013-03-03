class AddEndOfTripToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :end_of_trip, :datetime
  end

  def self.down
    remove_column :tickets, :end_of_trip
  end
end
