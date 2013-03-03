class CreateTickets < ActiveRecord::Migration
  def self.up
    create_table :tickets do |t|
      t.string :nameOfTrip
      t.date :date_of_trip
      t.time :timeOfTrip

      t.timestamps
    end
  end

  def self.down
    drop_table :tickets
  end
end

