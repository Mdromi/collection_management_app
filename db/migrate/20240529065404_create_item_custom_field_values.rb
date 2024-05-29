class CreateItemCustomFieldValues < ActiveRecord::Migration[7.1]
  def change
    create_table :item_custom_field_values do |t|
      t.references :item, null: false, foreign_key: true
      t.references :custom_field, null: false, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
