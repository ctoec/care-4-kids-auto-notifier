class CreateEventCursors < ActiveRecord::Migration[5.2]
  def change
    create_table :event_cursors do |t|
      t.string :key
      t.datetime :time

      t.timestamps
    end
  end
end
