class AddPostalcodeToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :postalcode, :string
  end

  def self.down
    remove_column :users, :postalcode
  end
end
