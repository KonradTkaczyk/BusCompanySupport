class RemoveSeats < ActiveRecord::Migration
  def self.up
    drop_table :seats
  end

  def self.down
  end
end

