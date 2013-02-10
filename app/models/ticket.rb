class Ticket < ActiveRecord::Base

attr_accessible :cityFrom, :cityTo, :dateOfTrip, :endOfTrip, :user_reserved_id, :bus_id, :nameOfSeat, :trip, :bought
  validates :cityFrom,  :presence   => true
  validates :cityTo,    :presence   => true
  validates :dateOfTrip,:presence   => true
  validates :endOfTrip, :presence   => true
  validates :nameOfSeat,:presence   => true
  validates :trip,      :presence   => true
  belongs_to :user
  belongs_to :bus

#trip - is used to group tickets in the trip - each trip is unique
#bought - is used to check if ticket was bought - this will be filled by driver before starting the bus.
#user_id - is used to recognize person who created a ticket
#user_reserved_id - is used to recognize a person who reserved a ticket
#bus_id - is used to recognize to which bus ticket is connected

  def cost_of_trip #Time cost of the trip used to calculate shortest path.
    (self.endOfTrip - self.dateOfTrip).round
  end

  def self.tickets_for_shortest_path (shortest)
    i = 0
    endoftrip = Time.now #starting time to search the tickets, then used as variable to find tickets after previous ticket ends so all tickets can line up in time.
    ticketsOfShortestPath = Array.new()
    while !shortest[i+1].nil?
      ticket2 = Ticket.where("user_reserved_id = 0 AND dateOfTrip > ? AND cityFrom = ? AND cityTo = ?",endoftrip, shortest[i], shortest[i + 1]).order("dateOfTrip ASC").limit(1)
      if(ticket2.length == 0)
        return nil
      end
      ticket2.each do |ticket|
        endoftrip = ticket.endOfTrip
        ticketsOfShortestPath.push(ticket)
        i = i + 1
      end
    end
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

