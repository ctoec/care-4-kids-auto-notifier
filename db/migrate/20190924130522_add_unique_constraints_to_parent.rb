class AddUniqueConstraintsToParent < ActiveRecord::Migration[6.0]
  def change
    add_index :parents, :caseid, :unique => true
    add_index :parents, :encrypted_cellphonenumber, :unique => true
  end
end
