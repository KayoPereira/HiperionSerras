class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :line
      t.references :subcategory, null: false, foreign_key: true
      t.text :characteristics
      t.text :applications
      t.text :types_of_coatings
      t.text :details

      t.timestamps
    end
  end
end
