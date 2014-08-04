class CreateLinkedInInvitations < ActiveRecord::Migration
  def change
    create_table :linked_in_invitations do |t|
      t.string :name
      t.datetime :date_sent
      t.boolean :accepted
      t.string :initiator
      t.string :invitation_id
      t.integer :contact_id
      t.integer :user_id
      t.timestamps
    end
    add_index :linked_in_invitations, :contact_id
    add_index :linked_in_invitations, :user_id
  end
end
