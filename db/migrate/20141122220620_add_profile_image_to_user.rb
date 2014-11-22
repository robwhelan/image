class AddProfileImageToUser < ActiveRecord::Migration
  def change
    add_column :users, :profile_image, :string
    add_column :users, :fullname, :string
  end
end
