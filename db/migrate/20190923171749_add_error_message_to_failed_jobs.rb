class AddErrorMessageToFailedJobs < ActiveRecord::Migration[6.0]
  def change
    add_column :failed_jobs, :error_message, :string
  end
end
