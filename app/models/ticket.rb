class Ticket < ActiveRecord::Base
  attr_accessible :nameOfTrip, :dateOfTrip, :timeOfTrip, :user_reserved_id

  belongs_to :user
end



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
#

