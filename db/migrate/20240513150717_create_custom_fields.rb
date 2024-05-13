class CreateCustomFields < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_fields do |t|
      t.string :label
      t.string :data_type
      t.references :collection, null: false, foreign_key: true

      t.timestamps
    end
  end
end
