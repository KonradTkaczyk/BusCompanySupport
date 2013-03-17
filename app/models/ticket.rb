class Ticket < ActiveRecord::Base

attr_accessible :city_from, :city_to, :date_of_trip, :end_of_trip, :user_reserved_id, :bus_id, :name_of_seat, :trip, :bought
  validates :city_from,  :presence   => true
  validates :city_to,    :presence   => true
  validates :date_of_trip,:presence   => true
  validates :end_of_trip, :presence   => true
  validates :name_of_seat,:presence   => true
  validates :trip,      :presence   => true
  validates_datetime :date_of_trip
  validates_datetime :end_of_trip
  belongs_to :user
  belongs_to :bus

#trip - is used to group tickets in the trip - each trip is unique
#bought - is used to check if ticket was bought - this will be filled by driver before starting the bus.
#user_id - is used to recognize person who created a ticket
#user_reserved_id - is used to recognize a person who reserved a ticket
#bus_id - is used to recognize to which bus ticket is connected

  def cost_of_trip #Time cost of the trip used to calculate shortest path.
    (self.end_of_trip - self.date_of_trip).round
  end

  def self.tickets_for_shortest_path (shortest)
    i = 0
    endoftrip = Time.now #starting time to search the tickets, then used as variable to find tickets after previous ticket ends so all tickets can line up in time.
    ticketsOfShortestPath = Array.new()
    while !shortest[i+1].nil?
      ticket2 = Ticket.where("user_reserved_id = 0 AND date_of_trip > ? AND city_from = ? AND city_to = ?",endoftrip, shortest[i], shortest[i + 1]).order("date_of_trip ASC").first
      if (ticket2 == nil)
        return nil
      end
      endoftrip = ticket2.end_of_trip
      @ticket = Ticket.where("user_reserved_id = 0 AND trip = ?",ticket2.trip)#Find all tickets from same trip
      @ticket.each do |x|
        ticketsOfShortestPath.push(x)
      end
      i = i + 1
    end
    return ticketsOfShortestPath
  end

  def self.reserve_all(arrayOfTrips,current_user)
    arrayOfTrips.each do |x| #go through all arrays with seats sended via AJAX
      if(x.length>=2) #all arrays which have seats as they are from second element of the array
        tripid = nil
        x.each_with_index do |y,index| #go through all tickets for one trip, first element of array is trip ID
          if(index == 0)
            tripid = y
          else
            ticket = Ticket.where("user_reserved_id = 0 AND trip = ? AND name_of_seat = ?",tripid,y).first
            ticket.user_reserved_id = current_user.id
            ticket.save
          end
        end
      end
    end
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
#  name_of_seat       :string(255)
#  bus_id           :integer
#  date_of_trip       :datetime
#  city_from         :string(255)
#  city_to           :string(255)
#  end_of_trip        :datetime
#

