class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :zip_code
      t.string :handle_phone
      t.string :handle_email
      t.string :handle_linked_in
      t.integer :user_id
      t.timestamps
    end
    add_index :contacts, :user_id
  end
end
