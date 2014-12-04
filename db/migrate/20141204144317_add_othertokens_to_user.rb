class AddOthertokensToUser < ActiveRecord::Migration
  def change
    add_column :users, :google_refresh_token, :string
    add_column :users, :google_expires_at, :datetime
  end
end
