class AddNotificationsGeneratedCountToParents < ActiveRecord::Migration[6.0]
  def change
    add_column :parents, :notifications_generated_count, :integer, default: 0, null: false
  end
end
