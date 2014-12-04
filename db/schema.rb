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

ActiveRecord::Schema.define(:version => 20141204144317) do

  create_table "call_verizons", :force => true do |t|
    t.datetime "call_date"
    t.string   "call_direction"
    t.string   "contact_number"
    t.string   "call_duration"
    t.integer  "contact_id"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "batch_id"
  end

  add_index "call_verizons", ["contact_id"], :name => "index_call_verizons_on_contact_id"
  add_index "call_verizons", ["user_id"], :name => "index_call_verizons_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contact_id"
    t.string   "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "comments", ["contact_id"], :name => "index_comments_on_contact_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "show_as_actionable", :default => true
    t.string   "fullname"
    t.string   "profile_image"
  end

  add_index "contacts", ["user_id"], :name => "index_contacts_on_user_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

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
    t.integer  "batch_id"
  end

  add_index "email_gmails", ["contact_id"], :name => "index_email_gmails_on_contact_id"
  add_index "email_gmails", ["user_id"], :name => "index_email_gmails_on_user_id"

  create_table "emails", :force => true do |t|
    t.string   "email"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "emails", ["contact_id"], :name => "index_emails_on_contact_id"

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
    t.integer  "batch_id"
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
    t.integer  "batch_id"
  end

  add_index "linked_in_messages", ["contact_id"], :name => "index_linked_in_messages_on_contact_id"
  add_index "linked_in_messages", ["user_id"], :name => "index_linked_in_messages_on_user_id"

  create_table "new_comms", :force => true do |t|
    t.integer  "email_in"
    t.integer  "email_out"
    t.integer  "text_in"
    t.integer  "text_out"
    t.integer  "call_in"
    t.integer  "call_out"
    t.integer  "li_invite_in"
    t.integer  "li_invite_out"
    t.integer  "li_message_in"
    t.integer  "li_message_out"
    t.integer  "user_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "new_comms", ["user_id"], :name => "index_new_comms_on_user_id"

  create_table "phones", :force => true do |t|
    t.string   "phone"
    t.integer  "contact_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "phones", ["contact_id"], :name => "index_phones_on_contact_id"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "text_verizons", :force => true do |t|
    t.datetime "text_date"
    t.string   "text_contact_number"
    t.string   "text_direction"
    t.integer  "contact_id"
    t.integer  "user_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "batch_id"
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
    t.string   "email",                        :default => "", :null => false
    t.string   "encrypted_password",           :default => "", :null => false
    t.string   "handle_phone"
    t.string   "handle_linked_in"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "encrypted_email_user"
    t.string   "encrypted_email_password"
    t.string   "encrypted_linked_in_username"
    t.string   "encrypted_linked_in_password"
    t.string   "encrypted_verizon_primary"
    t.string   "encrypted_verizon_secret"
    t.string   "encrypted_verizon_password"
    t.string   "encrypted_verizon_data"
    t.string   "vault_password"
    t.string   "token"
    t.string   "uid"
    t.string   "provider"
    t.string   "profile_image"
    t.string   "fullname"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "google_refresh_token"
    t.datetime "google_expires_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
