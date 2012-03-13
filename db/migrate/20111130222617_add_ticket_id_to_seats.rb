class AddTicketIdToSeats < ActiveRecord::Migration
  def self.up
    add_column :seats, :ticket_id, :integer
    add_index :seats, :ticket_id
  end

  def self.down
    remove_index :seats, :ticket_id
    remove_column :seats, :ticket_id
  end
end

