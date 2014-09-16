class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :contact
      t.string :body

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :contact_id
  end
end
