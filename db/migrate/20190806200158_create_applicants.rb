class CreateParents < ActiveRecord::Migration[5.2]
  def change
    create_table :parents do |t|
      t.string :caseid
      t.string :cellphonenumber

      t.timestamps
    end
  end
end
