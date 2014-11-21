class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :phone
      t.belongs_to :contact

      t.timestamps
    end
    add_index :phones, :contact_id
  end
end
