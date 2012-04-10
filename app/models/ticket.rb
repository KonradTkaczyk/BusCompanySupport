class Ticket < ActiveRecord::Base
  attr_accessible :nameOfTrip, :dateOfTrip, :timeOfTrip, :user_reserved_id, :bus_id
  belongs_to :user
  belongs_to :bus

  validates :nameOfTrip,      :presence   => true,
                              :length     => { :maximum => 50 }

end
#user_id - is used to recognize person who created a ticket
#user_reserved_id - is used to recognize a person who reserved a ticket



# == Schema Information
#
# Table name: tickets
#
#  id               :integer         not null, primary key
#  nameOfTrip       :string(255)
#  dateOfTrip       :date
#  timeOfTrip       :time
#  created_at       :datetime
#  updated_at       :datetime
#  user_id          :integer
#  user_reserved_id :integer
#  nameOfSeat       :string(255)
#  bus_id           :integer
#

