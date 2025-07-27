class AddIsServiceToProductsAndMakeSubcategoryOptional < ActiveRecord::Migration[8.0]
  def change
    # Adicionar coluna is_service como boolean com valor padrão false
    add_column :products, :is_service, :boolean, default: false, null: false

    # Tornar subcategory_id opcional (permitir null)
    change_column_null :products, :subcategory_id, true
  end
end
