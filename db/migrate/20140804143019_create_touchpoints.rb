class CreateTouchpoints < ActiveRecord::Migration
  def change
    create_table :touchpoints do |t|
      t.integer :subject_id, null: false
      t.string :subject_type, null: false
      t.belongs_to :user
      t.belongs_to :contact
      t.string :name, null: false
      t.string :direction, null: false
      t.date :touchpoint_date
      t.time :touchpoint_time

      t.timestamps
    end
    add_index :touchpoints, :subject_id
    add_index :touchpoints, :subject_type
    add_index :touchpoints, :user_id
    add_index :touchpoints, :contact_id
  end
end
