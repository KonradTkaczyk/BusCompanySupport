class AddSeatNameToTicket < ActiveRecord::Migration
  def self.up
    add_column :tickets, :name_of_seat, :string
  end

  def self.down
    remove_column :tickets, :name_of_seat
  end
end

