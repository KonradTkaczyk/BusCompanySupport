class FixColumnsName < ActiveRecord::Migration
  def self.up
    rename_column :tickets, :from, :city_from
    rename_column :tickets, :to, :city_to
  end
  def self.down
    rename_column :tickets, :city_from, :from
    rename_column :tickets, :city_to, :to
  end
end

