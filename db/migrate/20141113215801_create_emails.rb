class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :email
      t.belongs_to :contact

      t.timestamps
    end
    add_index :emails, :contact_id
  end
end
