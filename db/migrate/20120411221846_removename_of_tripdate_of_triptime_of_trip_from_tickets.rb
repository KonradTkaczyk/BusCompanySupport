class RemovenameOfTripdate_of_triptimeOfTripFromTickets < ActiveRecord::Migration
  def self.up
    remove_column :tickets, :nameOfTrip
    remove_column :tickets, :date_of_trip
    remove_column :tickets, :timeOfTrip
    remove_column :buses, :travel
    add_column :tickets, :date_of_trip, :datetime
  end

  def self.down
    add_column :tickets, :nameOfTrip, :string
    add_column :tickets, :date_of_trip, :date
    add_column :tickets, :timeOfTrip, :time
    add_column :buses , :travel, :string
    remove_column :tickets, :date_of_trip
  end
end

