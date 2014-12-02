class AddProfileImageToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :profile_image, :string
  end
end
