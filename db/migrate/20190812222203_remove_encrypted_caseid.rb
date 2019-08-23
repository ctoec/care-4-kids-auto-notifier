class RemoveEncryptedCaseid < ActiveRecord::Migration[5.2]
  def change
    remove_column :parents, :encrypted_caseid
    remove_column :parents, :encrypted_caseid_iv
    add_column :parents, :caseid, :string
  end
end
