namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = make_users
    make_buses(admin)
    make_tickets(admin)
  end
end

def make_users
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
      User.create!(:name => name,
                   :email => email,
                   :password => password,
                   :password_confirmation => password,
                   :surname => "user",
                   :postalcode => "00-000")
    end
    return admin
end

def make_buses (admin)
  10.times do |n|
    admin.buses.create!(:capacity => 10, :nameOfBus => "exampleBus-#{n+1}")
  end
end

def make_tickets (admin)
  time = Time.now
  10.times do |m|
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days, :endOfTrip => time + 2.days + m.days + 2.hours, :bus_id => 1, :cityFrom => "Warsaw", :cityTo => "Ciechanow", :nameOfSeat => "#{n+1}", :trip => "#{m*12+1}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 2.hours, :endOfTrip => time + 2.days + m.days + 4.hours, :bus_id => 1, :cityFrom => "Ciechanow", :cityTo => "Warsaw", :nameOfSeat => "#{n+1}", :trip => "#{m*12+2}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 4.hours, :endOfTrip => time + 2.days + m.days + 8.hours, :bus_id => 2, :cityFrom => "Ciechanow", :cityTo => "Gdansk", :nameOfSeat => "#{n+1}", :trip => "#{m*12+3}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 8.hours, :endOfTrip => time + 2.days + m.days + 12.hours, :bus_id => 2, :cityFrom => "Gdansk", :cityTo => "Ciechanow", :nameOfSeat => "#{n+1}", :trip => "#{m*12+4}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 4.hours, :endOfTrip => time + 2.days + m.days + 6.hours, :bus_id => 3, :cityFrom => "Ciechanow", :cityTo => "Olsztyn", :nameOfSeat => "#{n+1}", :trip => "#{m*12+5}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 8.hours, :endOfTrip => time + 2.days + m.days + 10.hours, :bus_id => 3, :cityFrom => "Olsztyn", :cityTo => "Ciechanow", :nameOfSeat => "#{n+1}", :trip => "#{m*12+6}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days, :endOfTrip => time + 2.days + m.days + 2.hours, :bus_id => 4, :cityFrom  => "Warsaw", :cityTo => "Radom", :nameOfSeat => "#{n+1}", :trip => "#{m*12+7}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 2.hours, :endOfTrip => time + 2.days + m.days + 4.hours, :bus_id => 4, :cityFrom => "Radom", :cityTo => "Warsaw", :nameOfSeat => "#{n+1}", :trip => "#{m*12+8}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 2.hours, :endOfTrip => time + 2.days + m.days + 4.hours, :bus_id => 5, :cityFrom => "Gdansk", :cityTo => "Szczecin", :nameOfSeat => "#{n+1}", :trip => "#{m*12+9}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 5.hours, :endOfTrip => time + 2.days + m.days + 7.hours, :bus_id => 5, :cityFrom => "Szczecin", :cityTo => "Gdansk", :nameOfSeat => "#{n+1}", :trip => "#{m*12+10}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 5.hours, :endOfTrip => time + 2.days + m.days + 7.hours, :bus_id => 6, :cityFrom => "Olsztyn", :cityTo => "Gdansk", :nameOfSeat => "#{n+1}", :trip => "#{m*12+11}")
    end
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => time + 2.days + m.days + 8.hours, :endOfTrip => time + 2.days + m.days + 10.hours, :bus_id => 6, :cityFrom => "Gdansk", :cityTo => "Olsztyn", :nameOfSeat => "#{n+1}", :trip => "#{m*12+12}")
    end
  end
end

