class AddErrorCodeToFailedJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :failed_jobs, :error_code, :integer
  end
end
