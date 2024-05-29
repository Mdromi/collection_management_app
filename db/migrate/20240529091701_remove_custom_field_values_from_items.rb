class RemoveCustomFieldValuesFromItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :custom_field_values
  end
end
