class ChangeUserReservedId < ActiveRecord::Migration
  def self.up
    change_column :tickets, :user_reserved_id, :integer, :default => 0
  end

  def self.down
  end
end

