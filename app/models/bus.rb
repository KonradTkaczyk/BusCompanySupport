class Bus < ActiveRecord::Base
  validates :capacity, :numericality => { :only_integer => true, :greater_than => 0 }
  has_many :tickets
end


# == Schema Information
#
# Table name: buses
#
#  id         :integer         not null, primary key
#  nameOfBus  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  capacity   :integer
#

