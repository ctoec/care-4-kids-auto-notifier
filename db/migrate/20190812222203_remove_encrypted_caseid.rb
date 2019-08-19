class RemoveEncryptedCaseid < ActiveRecord::Migration[5.2]
  def change
    remove_column :applicants, :encrypted_caseid
    remove_column :applicants, :encrypted_caseid_iv
    add_column :applicants, :caseid, :string
  end
end
