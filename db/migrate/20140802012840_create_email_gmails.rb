class CreateEmailGmails < ActiveRecord::Migration
  def change
    create_table :email_gmails do |t|
      t.datetime :date_sent
      t.string :subject
      t.string :contact_email
      t.string :direction
      t.string :contact_name
      t.string :message_id
      t.integer :contact_id
      t.integer :user_id
      t.timestamps
    end
    add_index :email_gmails, :contact_id
    add_index :email_gmails, :user_id
  end
end
