class Seat < ActiveRecord::Base
  belongs_to :bus
  belongs_to :ticket
end

# == Schema Information
#
# Table name: seats
#
#  id         :integer         not null, primary key
#  nameOfSeat :string(255)
#  created_at :datetime
#  updated_at :datetime
#

