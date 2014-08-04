class CreateCallVerizons < ActiveRecord::Migration
  def change
    create_table :call_verizons do |t|
      t.datetime :call_date
      t.string :call_direction
      t.string :contact_number
      t.string :call_duration
      t.integer :contact_id
      t.integer :user_id
      t.timestamps
    end
    add_index :call_verizons, :contact_id
    add_index :call_verizons, :user_id
  end
end
