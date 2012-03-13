class Bus < ActiveRecord::Base
  has_many :seats
end

# == Schema Information
#
# Table name: buses
#
#  id         :integer         not null, primary key
#  nameOfBus  :string(255)
#  travel     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

