namespace :db do
  desc "Dill database with sample data"
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
      email = "example-#{n+1}@user.org"
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
    10.times do |n|
      admin.tickets.create!(:dateOfTrip => Time.now + 2.days + n.days, :endOfTrip => Time.now + 2.days + n.days + 2.hours, :bus_id => 1, :cityFrom => "Warsaw", :cityTo => "Ciechanow", :nameOfSeat => "#{n+1}")
      admin.tickets.create!(:dateOfTrip => Time.now + 2.days + n.days + 2.hours, :endOfTrip => Time.now + 2.days + n.days + 4.hours, :bus_id => 1, :cityFrom => "Ciechanow", :cityTo => "Warsaw", :nameOfSeat => "#{n+1}")
      admin.tickets.create!(:dateOfTrip => Time.now + 2.days + n.days + 4.hours, :endOfTrip => Time.now + 2.days + n.days + 8.hours, :bus_id => 2, :cityFrom => "Ciechanow", :cityTo => "Gdansk", :nameOfSeat => "#{n+1}")
      admin.tickets.create!(:dateOfTrip => Time.now + 2.days + n.days + 4.hours, :endOfTrip => Time.now + 2.days + n.days + 6.hours, :bus_id => 3, :cityFrom => "Ciechanow", :cityTo => "Olsztyn", :nameOfSeat => "#{n+1}")
      admin.tickets.create!(:dateOfTrip => Time.now + 2.days + n.days, :endOfTrip => Time.now + 2.days + n.days + 2.hours, :bus_id => 4, :cityFrom  => "Warsaw", :cityTo => "Radom", :nameOfSeat => "#{n+1}")
      admin.tickets.create!(:dateOfTrip => Time.now + 2.days + n.days + 2.hours, :endOfTrip => Time.now + 2.days + n.days + 4.hours, :bus_id => 4, :cityFrom => "Radom", :cityTo => "Warsaw", :nameOfSeat => "#{n+1}")
    end
end

