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

ActiveRecord::Schema.define(:version => 20140802022020) do

  create_table "call_verizons", :force => true do |t|
    t.string   "call_date"
    t.string   "call_time"
    t.string   "call_direction"
    t.string   "contact_number"
    t.string   "call_duration"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "email_gmails", :force => true do |t|
    t.date     "date_sent"
    t.string   "subject"
    t.string   "contact_email"
    t.string   "direction"
    t.string   "contact_name"
    t.string   "message_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "linked_in_invitations", :force => true do |t|
    t.string   "name"
    t.date     "date_sent"
    t.boolean  "accepted"
    t.string   "initiator"
    t.string   "invitation_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "linked_in_messages", :force => true do |t|
    t.string   "name"
    t.date     "date_sent"
    t.string   "initiator"
    t.boolean  "is_a_reply_to_outbound"
    t.string   "message_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  create_table "text_verizons", :force => true do |t|
    t.string   "text_date"
    t.string   "text_time"
    t.string   "text_contact_number"
    t.string   "text_direction"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

end
