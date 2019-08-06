class CreateApplicants < ActiveRecord::Migration[5.2]
  def change
    create_table :applicants do |t|
      t.string :caseid
      t.string :cellphonenumber

      t.timestamps
    end
  end
end
