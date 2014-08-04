class CreateLinkedInMessages < ActiveRecord::Migration
  def change
    create_table :linked_in_messages do |t|
      t.string :name
      t.datetime :date_sent
      t.string :initiator
      t.boolean :is_a_reply_to_outbound
      t.string :message_id
      t.integer :contact_id
      t.integer :user_id
      t.timestamps
    end
    add_index :linked_in_messages, :contact_id
    add_index :linked_in_messages, :user_id
  end
end
