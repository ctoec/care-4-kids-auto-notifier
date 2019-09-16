class ChangeNotificationMessageTextToTextType < ActiveRecord::Migration[6.0]
  def change
    change_column :notifications, :encrypted_message_text, :text
  end
end
