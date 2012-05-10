# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120510220152) do

  create_table "buses", :force => true do |t|
    t.string   "nameOfBus"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "capacity"
  end

  create_table "tickets", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "user_reserved_id", :default => 0
    t.string   "nameOfSeat"
    t.integer  "bus_id"
    t.datetime "dateOfTrip"
    t.string   "from"
    t.string   "to"
    t.datetime "endOfTrip"
  end

  add_index "tickets", ["user_id"], :name => "index_tickets_on_user_id"
  add_index "tickets", ["user_reserved_id"], :name => "index_tickets_on_user_reserved_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin",              :default => false
    t.string   "surname"
    t.date     "birthday"
    t.boolean  "gender"
    t.string   "address"
    t.string   "city"
    t.string   "postalcode"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
