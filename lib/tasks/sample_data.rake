namespace :db do
  desc "Dill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = make_users
    #make_buses(admin)
    #make_tickets(admin)
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
  admin.buses.create!()
end

def make_tickets (admin,bus)
  admin.tickets.create!()
end

