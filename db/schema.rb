# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130519193654) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.time     "open_time"
    t.time     "close_time"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "departments_employees", :id => false, :force => true do |t|
    t.integer "department_id"
    t.integer "employee_id"
  end

  create_table "employees", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "middle_name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
  end

  create_table "shifts", :force => true do |t|
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "department_id"
    t.integer  "employee_id"
    t.string   "type"
    t.string   "category"
  end

  create_table "time_offs", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "identifier_url"
  end

  add_index "users", ["identifier_url"], :name => "index_users_on_identifier_url", :unique => true

end
