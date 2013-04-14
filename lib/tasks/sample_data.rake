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
  @genders = [true,false]#true - man, false - woman
    admin = User.create!( :name => "Admin",
                  :email => "admin@bcs.org",
                  :password => "foobar",
                  :password_confirmation => "foobar",
                  :surname => "Admin",
                  :postalcode => "00-000",
                  :gender => @genders.rand)
    admin.toggle!(:admin)
    User.create!( :name => "Example User",
              :email => "user@bcs.org",
              :password => "foobar",
              :password_confirmation => "foobar",
              :surname => "user",
              :postalcode => "00-000",
              :gender => @genders.rand)
    driver = User.create!( :name => "Driver",
              :email => "driver@bcs.org",
              :password => "foobar",
              :password_confirmation => "foobar",
              :surname => "user",
              :postalcode => "00-000",
              :gender => @genders.rand)
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
                   :postalcode => "00-000",
                   :gender => @genders.rand)
      if n.modulo(10) == 0 #each 10th user becomes driver
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
     make_10_tickets(admin,m,"Olsztyn","Gdansk",6,time,5,7)
     make_10_tickets(admin,m,"Gdansk","Olsztyn",6,time,8,10)
     make_10_tickets(admin,m,"Szczecin","Opole",7,time,12,14)
     make_10_tickets(admin,m,"Opole","Wroclaw",7,time,15,17)
     make_10_tickets(admin,m,"Wroclaw","Cracow",7,time,18,22)
     make_10_tickets(admin,m,"Cracow","Warsaw",8,time,8,12)
     make_10_tickets(admin,m,"Warsaw","Cracow",8,time,13,17)
     make_10_tickets(admin,m,"Cracow","Wroclaw",8,time,18,20)
     make_10_tickets(admin,m,"Cracow","Rzeszow",9,time,18,22)
     make_10_tickets(admin,m,"Rzeszow","Lublin",9,time,23,26)
     make_10_tickets(admin,m,"Lublin","Warsaw",9,time,29,31)
     make_10_tickets(admin,m,"Lublin","Radom",10,time,18,21)
     make_10_tickets(admin,m,"Radom","Warsaw",10,time,22,24)
  end
end

