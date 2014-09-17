class AddBatchToModels < ActiveRecord::Migration
  def change
    add_column :call_verizons, :batch_id, :integer
    add_column :text_verizons, :batch_id, :integer
    add_column :linked_in_messages, :batch_id, :integer
    add_column :linked_in_invitations, :batch_id, :integer
    add_column :email_gmails, :batch_id, :integer
  end
end
