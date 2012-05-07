class Ticket < ActiveRecord::Base
  attr_accessible :from, :to, :dateOfTrip, :user_reserved_id, :bus_id
  belongs_to :user
  belongs_to :bus


end
#user_id - is used to recognize person who created a ticket
#user_reserved_id - is used to recognize a person who reserved a ticket
#bus_id - is used to recognize to which bus ticket is connected



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
#  from             :string(255)
#  to               :string(255)
#

