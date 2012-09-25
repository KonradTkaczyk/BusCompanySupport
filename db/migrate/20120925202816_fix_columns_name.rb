class FixColumnsName < ActiveRecord::Migration
  def self.up
    rename_column :tickets, :from, :cityFrom
    rename_column :tickets, :to, :cityTo
  end
  def self.down
    rename_column :tickets, :cityFrom, :from
    rename_column :tickets, :cityTo, :to
  end
end

