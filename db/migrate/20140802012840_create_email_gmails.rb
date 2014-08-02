class CreateEmailGmails < ActiveRecord::Migration
  def change
    create_table :email_gmails do |t|
      t.date :date_sent
      t.string :subject
      t.string :contact_email
      t.string :direction
      t.string :contact_name
      t.string :message_id

      t.timestamps
    end
  end
end
