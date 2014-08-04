class CreateLinkedInInvitations < ActiveRecord::Migration
  def change
    create_table :linked_in_invitations do |t|
      t.string :name
      t.date :date_sent
      t.boolean :accepted
      t.string :initiator
      t.string :invitation_id
      t.boolean :unassigned_contact

      t.timestamps
    end
  end
end
