class CreateLinkedInMessages < ActiveRecord::Migration
  def change
    create_table :linked_in_messages do |t|
      t.string :name
      t.date :date_sent
      t.string :initiator
      t.boolean :is_a_reply_to_outbound

      t.timestamps
    end
  end
end