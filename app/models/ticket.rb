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

  def self.tickets_for_shortest_path (shortest)
    i = 0
    ticketsOfShortestPath = Array.new()
    while !shortest[i+1].nil?
      ticket2 = Ticket.where("user_reserved_id = 0 AND dateOfTrip > ? AND cityFrom = ? AND cityTo = ?",Time.now, shortest[i], shortest[i + 1]).order("dateOfTrip ASC").limit(1)
      ticket2.each do |ticket|
        logger.debug ticket.cityFrom
        logger.debug i
        ticketsOfShortestPath.push(ticket)
        i = i + 1
      end
    end
    logger.debug ticketsOfShortestPath
    return ticketsOfShortestPath
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

