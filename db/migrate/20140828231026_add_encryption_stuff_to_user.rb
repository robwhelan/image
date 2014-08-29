class AddEncryptionStuffToUser < ActiveRecord::Migration
  def change
    add_column :users, :encrypted_email_user, :string
    add_column :users, :encrypted_email_password, :string
    add_column :users, :encrypted_linked_in_username, :string
    add_column :users, :encrypted_linked_in_password, :string
    add_column :users, :encrypted_verizon_primary, :string
    add_column :users, :encrypted_verizon_secret, :string
    add_column :users, :encrypted_verizon_password, :string
    add_column :users, :encrypted_verizon_data, :string
    add_column :users, :vault_password, :string
  end
end
