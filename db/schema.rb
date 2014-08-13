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

ActiveRecord::Schema.define(:version => 20140804144024) do

  create_table "call_verizons", :force => true do |t|
    t.datetime "call_date"
    t.string   "call_direction"
    t.string   "contact_number"
    t.string   "call_duration"
    t.integer  "contact_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "call_verizons", ["contact_id"], :name => "index_call_verizons_on_contact_id"
  add_index "call_verizons", ["user_id"], :name => "index_call_verizons_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "zip_code"
    t.string   "handle_phone"
    t.string   "handle_email"
    t.string   "handle_linked_in"
    t.integer  "user_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "email_gmails", :force => true do |t|
    t.datetime "date_sent"
    t.string   "subject"
    t.string   "contact_email"
    t.string   "direction"
    t.string   "contact_name"
    t.string   "message_id"
    t.integer  "contact_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "email_gmails", ["contact_id"], :name => "index_email_gmails_on_contact_id"
  add_index "email_gmails", ["user_id"], :name => "index_email_gmails_on_user_id"

  create_table "linked_in_invitations", :force => true do |t|
    t.string   "name"
    t.datetime "date_sent"
    t.boolean  "accepted"
    t.string   "initiator"
    t.string   "invitation_id"
    t.integer  "contact_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "linked_in_invitations", ["contact_id"], :name => "index_linked_in_invitations_on_contact_id"
  add_index "linked_in_invitations", ["user_id"], :name => "index_linked_in_invitations_on_user_id"

  create_table "linked_in_messages", :force => true do |t|
    t.string   "name"
    t.datetime "date_sent"
    t.string   "initiator"
    t.boolean  "is_a_reply_to_outbound"
    t.string   "message_id"
    t.integer  "contact_id"
    t.integer  "user_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "linked_in_messages", ["contact_id"], :name => "index_linked_in_messages_on_contact_id"
  add_index "linked_in_messages", ["user_id"], :name => "index_linked_in_messages_on_user_id"

  create_table "text_verizons", :force => true do |t|
    t.datetime "text_date"
    t.string   "text_contact_number"
    t.string   "text_direction"
    t.integer  "contact_id"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "text_verizons", ["contact_id"], :name => "index_text_verizons_on_contact_id"
  add_index "text_verizons", ["user_id"], :name => "index_text_verizons_on_user_id"

  create_table "touchpoints", :force => true do |t|
    t.integer  "subject_id",      :null => false
    t.string   "subject_type",    :null => false
    t.integer  "user_id"
    t.integer  "contact_id"
    t.string   "name",            :null => false
    t.string   "direction",       :null => false
    t.date     "touchpoint_date"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "touchpoints", ["contact_id"], :name => "index_touchpoints_on_contact_id"
  add_index "touchpoints", ["subject_id"], :name => "index_touchpoints_on_subject_id"
  add_index "touchpoints", ["subject_type"], :name => "index_touchpoints_on_subject_type"
  add_index "touchpoints", ["user_id"], :name => "index_touchpoints_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "handle_phone"
    t.string   "handle_linked_in"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
