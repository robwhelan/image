class CreateCallVerizons < ActiveRecord::Migration
  def change
    create_table :call_verizons do |t|
      t.string :call_date
      t.string :call_time
      t.string :call_direction
      t.string :contact_number
      t.string :call_duration

      t.timestamps
    end
  end
end
