class AddEncryptedFieldsToParent < ActiveRecord::Migration[5.2]
  def change
    add_column :parents, :encrypted_caseid, :string
    add_column :parents, :encrypted_caseid_iv, :string
    add_column :parents, :encrypted_cellphonenumber, :string
    add_column :parents, :encrypted_cellphonenumber_iv, :string
    remove_column :parents, :caseid
    remove_column :parents, :cellphonenumber
  end
end
