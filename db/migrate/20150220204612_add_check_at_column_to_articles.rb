class AddCheckAtColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :check_at, :datetime
  end
end
