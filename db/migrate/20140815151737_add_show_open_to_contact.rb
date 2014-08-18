class AddShowOpenToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :show_as_actionable, :boolean, :default => true
  end
end
