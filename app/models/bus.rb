class Bus < ActiveRecord::Base
  validates :capacity, :numericality => { :only_integer => true, :greater_than => 0 }
  belongs_to :user
  has_many :tickets
end
#user_id - informs who created a bus
#driver_id - informs who is a driver of the bus_id




# == Schema Information
#
# Table name: buses
#
#  id         :integer         not null, primary key
#  nameOfBus  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  capacity   :integer
#  user_id    :integer
#  driver_id  :integer
#

