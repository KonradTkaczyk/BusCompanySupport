class AddFromAndToDestinationsToTickets < ActiveRecord::Migration
  def self.up
    add_column :tickets, :from, :string
    add_column :tickets, :to, :string
    add_column :buses, :capacity, :integer
  end

  def self.down
    remove_column :tickets, :to
    remove_column :tickets, :from
    remove_column :buses, :capacity
  end
end

