class AddSeatNameToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :nameOfSeat, :string
  end

  def self.down
    remove_column :tickets, :nameOfSeat
  end
end

