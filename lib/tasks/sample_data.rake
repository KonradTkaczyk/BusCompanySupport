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
    admin.buses.create!(:capacity => 10, :name_of_bus => "exampleBus-#{n+1}")
  end
end

def make_tickets (admin)
  time = Time.now
  10.times do |m|
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days, :end_of_trip => time + 2.days + m.days + 2.hours, :bus_id => 1, :city_from => "Warsaw", :city_to => "Ciechanow", :name_of_seat => "#{n+1}", :trip => "#{m*23+1}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 2.hours, :end_of_trip => time + 2.days + m.days + 4.hours, :bus_id => 1, :city_from => "Ciechanow", :city_to => "Warsaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+2}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 4.hours, :end_of_trip => time + 2.days + m.days + 8.hours, :bus_id => 2, :city_from => "Ciechanow", :city_to => "Gdansk", :name_of_seat => "#{n+1}", :trip => "#{m*23+3}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 8.hours, :end_of_trip => time + 2.days + m.days + 12.hours, :bus_id => 2, :city_from => "Gdansk", :city_to => "Ciechanow", :name_of_seat => "#{n+1}", :trip => "#{m*23+4}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 4.hours, :end_of_trip => time + 2.days + m.days + 6.hours, :bus_id => 3, :city_from => "Ciechanow", :city_to => "Olsztyn", :name_of_seat => "#{n+1}", :trip => "#{m*23+5}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 8.hours, :end_of_trip => time + 2.days + m.days + 10.hours, :bus_id => 3, :city_from => "Olsztyn", :city_to => "Ciechanow", :name_of_seat => "#{n+1}", :trip => "#{m*23+6}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days, :end_of_trip => time + 2.days + m.days + 2.hours, :bus_id => 4, :city_from  => "Warsaw", :city_to => "Radom", :name_of_seat => "#{n+1}", :trip => "#{m*23+7}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 2.hours, :end_of_trip => time + 2.days + m.days + 4.hours, :bus_id => 4, :city_from => "Radom", :city_to => "Warsaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+8}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 2.hours, :end_of_trip => time + 2.days + m.days + 4.hours, :bus_id => 5, :city_from => "Gdansk", :city_to => "Szczecin", :name_of_seat => "#{n+1}", :trip => "#{m*23+9}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 5.hours, :end_of_trip => time + 2.days + m.days + 7.hours, :bus_id => 5, :city_from => "Szczecin", :city_to => "Gdansk", :name_of_seat => "#{n+1}", :trip => "#{m*23+10}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 5.hours, :end_of_trip => time + 2.days + m.days + 7.hours, :bus_id => 6, :city_from => "Olsztyn", :city_to => "Gdansk", :name_of_seat => "#{n+1}", :trip => "#{m*23+11}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 8.hours, :end_of_trip => time + 2.days + m.days + 10.hours, :bus_id => 6, :city_from => "Gdansk", :city_to => "Olsztyn", :name_of_seat => "#{n+1}", :trip => "#{m*23+12}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 12.hours, :end_of_trip => time + 2.days + m.days + 14.hours, :bus_id => 7, :city_from => "Szczecin", :city_to => "Opole", :name_of_seat => "#{n+1}", :trip => "#{m*23+13}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 15.hours, :end_of_trip => time + 2.days + m.days + 17.hours, :bus_id => 7, :city_from => "Opole", :city_to => "Wroclaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+14}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 22.hours, :bus_id => 7, :city_from => "Wroclaw", :city_to => "Cracow", :name_of_seat => "#{n+1}", :trip => "#{m*23+15}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 8.hours, :end_of_trip => time + 2.days + m.days + 12.hours, :bus_id => 8, :city_from => "Cracow", :city_to => "Warsaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+16}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 13.hours, :end_of_trip => time + 2.days + m.days + 17.hours, :bus_id => 8, :city_from => "Warsaw", :city_to => "Cracow", :name_of_seat => "#{n+1}", :trip => "#{m*23+17}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 20.hours, :bus_id => 8, :city_from => "Cracow", :city_to => "Wroclaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+18}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 22.hours, :bus_id => 9, :city_from => "Cracow", :city_to => "Rzeszow", :name_of_seat => "#{n+1}", :trip => "#{m*23+19}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 23.hours, :end_of_trip => time + 3.days + m.days + 2.hours, :bus_id => 9, :city_from => "Rzeszow", :city_to => "Lublin", :name_of_seat => "#{n+1}", :trip => "#{m*23+20}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 3.days + m.days + 3.hours, :end_of_trip => time + 3.days + m.days + 6.hours, :bus_id => 9, :city_from => "Lublin", :city_to => "Warsaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+21}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 21.hours, :bus_id => 10, :city_from => "Lublin", :city_to => "Radom", :name_of_seat => "#{n+1}", :trip => "#{m*23+22}")
    end
    10.times do |n|
      admin.tickets.create!(:date_of_trip => time + 2.days + m.days + 18.hours, :end_of_trip => time + 2.days + m.days + 20.hours, :bus_id => 10, :city_from => "Radom", :city_to => "Warsaw", :name_of_seat => "#{n+1}", :trip => "#{m*23+23}")
    end
  end
end

