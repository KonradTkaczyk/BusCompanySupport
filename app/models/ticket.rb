class Ticket < ActiveRecord::Base

attr_accessible :cityFrom, :cityTo, :dateOfTrip, :endOfTrip, :user_reserved_id, :bus_id, :nameOfSeat
  belongs_to :user
  belongs_to :bus
  validates_datetime :dateOfTrip
  validates_datetime :endOfTrip

#user_id - is used to recognize person who created a ticket
#user_reserved_id - is used to recognize a person who reserved a ticket
#bus_id - is used to recognize to which bus ticket is connected

  def cost_of_trip #Time cost of the trip used to calculate shortest path.
    (self.endOfTrip - self.dateOfTrip).round
  end

end



# == Schema Information
#
# Table name: tickets
#
#  id               :integer         not null, primary key
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  user_reserved_id :integer         default(0)
#  nameOfSeat       :string(255)
#  bus_id           :integer
#  dateOfTrip       :datetime
#  cityFrom         :string(255)
#  cityTo           :string(255)
#  endOfTrip        :datetime
#

