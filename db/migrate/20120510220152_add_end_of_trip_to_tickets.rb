class AddEndOfTripToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :endOfTrip, :datetime
  end

  def self.down
    remove_column :tickets, :endOfTrip
  end
end
