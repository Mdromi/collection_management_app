class AddItemsCountToCollections < ActiveRecord::Migration[7.1]
  def change
    add_column :collections, :items_count, :integer, default: 0
  end
end
