class AddHashColumnToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :unique_hash, :string
  end
end
