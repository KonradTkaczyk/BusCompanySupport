class CreateBuses < ActiveRecord::Migration
  def self.up
    create_table :buses do |t|
      t.string :name_of_bus
      t.string :travel

      t.timestamps
    end
  end

  def self.down
    drop_table :buses
  end
end
