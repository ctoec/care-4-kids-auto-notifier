class AddActiveToParents < ActiveRecord::Migration[6.0]
  def change
    add_column :parents, :active, :boolean, default: false, null: false
  end
end
