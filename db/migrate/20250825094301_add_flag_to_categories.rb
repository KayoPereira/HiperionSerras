class AddFlagToCategories < ActiveRecord::Migration[8.0]
  def change
    add_column :categories, :show_in_homepage, :boolean, default: false, null: false
  end
end
