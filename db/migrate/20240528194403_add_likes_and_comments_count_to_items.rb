class AddLikesAndCommentsCountToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :likes_count, :integer, default: 0
    add_column :items, :comments_count, :integer, default: 0
  end
end
