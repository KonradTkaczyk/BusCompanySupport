class AddSurnameToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :surname, :string
  end

  def self.down
    remove_column :users, :surname
  end
end
