class CreateTextVerizons < ActiveRecord::Migration
  def change
    create_table :text_verizons do |t|
      t.datetime :text_date
      t.string :text_contact_number
      t.string :text_direction
      t.integer :contact_id
      t.integer :user_id
      t.timestamps
    end
    add_index :text_verizons, :contact_id
    add_index :text_verizons, :user_id
  end
end
