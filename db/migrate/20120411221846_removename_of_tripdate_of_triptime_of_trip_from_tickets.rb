class RemovenameOfTripdateOfTriptimeOfTripFromTickets < ActiveRecord::Migration
  def self.up
    remove_column :tickets, :nameOfTrip
    remove_column :tickets, :dateOfTrip
    remove_column :tickets, :timeOfTrip
    remove_column :buses, :travel
    add_column :tickets, :dateOfTrip, :datetime
  end

  def self.down
    add_column :tickets, :nameOfTrip, :string
    add_column :tickets, :dateOfTrip, :date
    add_column :tickets, :timeOfTrip, :time
    add_column :buses , :travel, :string
    remove_column :tickets, :dateOfTrip
  end
end

