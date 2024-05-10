class RemoveTagsFromItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :tags, :string
  end
end
