class ConvertTagsToArrayInItems < ActiveRecord::Migration[7.1]
  def up
    # Add code to convert the tags column from string to array
    change_column :items, :tags, :text, array: true, default: []
  end

  def down
    # Add code to revert the change if needed
    change_column :items, :tags, :string
  end
end
