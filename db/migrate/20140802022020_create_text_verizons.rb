class CreateTextVerizons < ActiveRecord::Migration
  def change
    create_table :text_verizons do |t|
      t.string :text_date
      t.string :text_time
      t.string :text_contact_number
      t.string :text_direction

      t.timestamps
    end
  end
end
