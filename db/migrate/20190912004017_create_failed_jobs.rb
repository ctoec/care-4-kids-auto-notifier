class CreateFailedJobs < ActiveRecord::Migration[6.0]
  def change
    create_table :failed_jobs do |t|
      t.string :jobid
      t.datetime :failed_at
      t.references :notification, null: false, foreign_key: true
      t.references :parent, null: false, foreign_key: true

      t.timestamps
    end
  end
end
