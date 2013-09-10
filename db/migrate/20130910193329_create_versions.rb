class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.text :text
      t.integer :article_id

      t.timestamps
    end
  end
end
