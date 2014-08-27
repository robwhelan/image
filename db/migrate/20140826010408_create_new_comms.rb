class CreateNewComms < ActiveRecord::Migration
  def change
    create_table :new_comms do |t|
      t.integer :email_in
      t.integer :email_out
      t.integer :text_in
      t.integer :text_out
      t.integer :call_in
      t.integer :call_out
      t.integer :li_invite_in
      t.integer :li_invite_out
      t.integer :li_message_in
      t.integer :li_message_out
      t.integer :user_id
      t.timestamps

    end
    add_index :new_comms, :user_id
  end
end
