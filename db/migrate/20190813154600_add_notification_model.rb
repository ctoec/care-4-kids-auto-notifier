class AddNotificationModel < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :encrypted_message_text
      t.string :encrypted_message_text_iv
      t.timestamps
    end
  end
end
