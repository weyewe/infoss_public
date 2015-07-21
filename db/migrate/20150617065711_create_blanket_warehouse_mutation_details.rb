class CreateBlanketWarehouseMutationDetails < ActiveRecord::Migration
  def change
    create_table :blanket_warehouse_mutation_details do |t|
      t.integer :blanket_warehouse_mutation_id
      t.integer :blanket_order_detail_id
      t.string  :code
      t.integer :item_id
      
      t.integer  :quantity, :default => 0 
      
      t.boolean :is_confirmed , :default => false
      t.datetime  :confirmed_at
      t.timestamps
    end
  end
end
