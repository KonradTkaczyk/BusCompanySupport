class Bus < ActiveRecord::Base
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

