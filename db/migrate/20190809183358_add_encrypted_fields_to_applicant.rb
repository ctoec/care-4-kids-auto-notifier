class AddEncryptedFieldsToApplicant < ActiveRecord::Migration[5.2]
  def change
    add_column :applicants, :encrypted_caseid, :string
    add_column :applicants, :encrypted_caseid_iv, :string
    add_column :applicants, :encrypted_cellphonenumber, :string
    add_column :applicants, :encrypted_cellphonenumber_iv, :string
    remove_column :applicants, :caseid
    remove_column :applicants, :cellphonenumber
  end
end
