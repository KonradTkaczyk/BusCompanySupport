namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    drivers = Array.new
    admin = make_users(drivers)
    make_buses(admin,drivers)
    make_tickets(admin)
  end
end

def make_users(drivers)
    admin = User.create!( :name => "Admin",
                  :email => "admin@bcs.org",
                  :password => "foobar",
                  :password_confirmation => "foobar",
                  :surname => "Admin",
                  :postalcode => "00-000")
    admin.toggle!(:admin)
    User.create!( :name => "Example User",
              :email => "user@bcs.org",
              :password => "foobar",
              :password_confirmation => "foobar",
              :surname => "user",
              :postalcode => "00-000")
    driver = User.create!( :name => "Driver",
              :email => "driver@bcs.org",
              :password => "foobar",
              :password_confirmation => "foobar",
              :surname => "user",
              :postalcode => "00-000")
    driver.toggle!(:driver)
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@bcs.org"
      password = "password"
      user = User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password,
                   :surname => "user",
                   :postalcode => "00-000")
      if n.modulo(10) == 0
        user.toggle!(:driver)
        drivers.push(user)
      end
    end
    return admin
end

def make_buses (admin,drivers)
  10.times do |n|
    admin.buses.create!(:capacity => 10, :name_of_bus => "exampleBus-#{n+1}", :driver_id => drivers[n].id)
  end
end

def make_10_tickets(admin,m,city_from,city_to,bus_id, time, xhour1, xhour2)
  10.times do |n|
    admin.tickets.create!(:date_of_trip => time + 2.days + m.days + xhour1.hours, :end_of_trip => time + 2.days + m.days + xhour2.hours, :bus_id => bus_id, :city_from => city_from, :city_to => city_to, :name_of_seat => "#{n+1}", :trip => $trip)
  end
  $trip = $trip + 1
end

def make_tickets (admin)
  $trip = 1
  time = Time.now
  10.times do |m|
     make_10_tickets(admin,m,"Warsaw","Ciechanow",1,time,0,2)
     make_10_tickets(admin,m,"Ciechanow","Warsaw",1,time,2,4)
     make_10_tickets(admin,m,"Ciechanow","Gdansk",2,time,4,8)
     make_10_tickets(admin,m,"Gdansk","Ciechanow",2,time,8,12)
     make_10_tickets(admin,m,"Ciechanow","Olsztyn",3,time,4,6)
     make_10_tickets(admin,m,"Olsztyn","Ciechanow",3,time,8,10)
     make_10_tickets(admin,m,"Warsaw","Radom",4,time,0,2)
     make_10_tickets(admin,m,"Radom","Warsaw",4,time,2,4)
     make_10_tickets(admin,m,"Gdansk","Szczecin",5,time,2,4)
     make_10_tickets(admin,m,"Szczecin","Gdansk",5,time,5,7)

#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 5.hours, :end_of_trip => time + 2.days + m.days + 7.hours, :bus_id => 6, :city_from => "Olsztyn", :city_to => "Gdansk", :name_of_seat => "#{n+1}", :trip => "#{m*23+11}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 8.hours, :end_of_trip => time + 2.days + m.days + 10.hours, :bus_id => 6, :city_from => "Gdansk", :city_to => "Olsztyn", :name_of_seat => "#{n+1}", :trip => "#{m*23+12}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 12.hours, :end_of_trip => time + 2.days + m.days + 14.hours, :bus_id => 7, :city_from => "Szczecin", :city_to => "Opole", :name_of_seat => "#{n+1}", :trip => "#{m*23+13}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 15.hours, :end_of_trip => time + 2.days + m.days + 17.hours, :bus_id => 7, :city_from => "Opole", :city_to => "Wroclaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+14}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 22.hours, :bus_id => 7, :city_from => "Wroclaw", :city_to => "Cracow", :name_of_seat => "#{n+1}", :trip => "#{m*23+15}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 8.hours, :end_of_trip => time + 2.days + m.days + 12.hours, :bus_id => 8, :city_from => "Cracow", :city_to => "Warsaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+16}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 13.hours, :end_of_trip => time + 2.days + m.days + 17.hours, :bus_id => 8, :city_from => "Warsaw", :city_to => "Cracow", :name_of_seat => "#{n+1}", :trip => "#{m*23+17}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 20.hours, :bus_id => 8, :city_from => "Cracow", :city_to => "Wroclaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+18}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 22.hours, :bus_id => 9, :city_from => "Cracow", :city_to => "Rzeszow", :name_of_seat => "#{n+1}", :trip => "#{m*23+19}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 23.hours, :end_of_trip => time + 2.days + m.days + 26.hours, :bus_id => 9, :city_from => "Rzeszow", :city_to => "Lublin", :name_of_seat => "#{n+1}", :trip => "#{m*23+20}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 29.hours, :end_of_trip => time + 2.days + m.days + 30.hours, :bus_id => 9, :city_from => "Lublin", :city_to => "Warsaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+21}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 21.hours, :bus_id => 10, :city_from => "Lublin", :city_to => "Radom", :name_of_seat => "#{n+1}", :trip => "#{m*23+22}")
#    end
#    10.times do |n|
#      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 20.hours, :bus_id => 10, :city_from => "Radom", :city_to => "Warsaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+23}")
#    end
  end
end

