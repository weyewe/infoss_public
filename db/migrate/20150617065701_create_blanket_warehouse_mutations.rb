class CreateBlanketWarehouseMutations < ActiveRecord::Migration
  def change
    create_table :blanket_warehouse_mutations do |t|
      t.integer :blanket_order_id
      t.string  :code
      t.integer :warehouse_from_id
      t.integer :warehouse_to_id
      t.datetime  :mutation_date
     
      t.boolean :is_confirmed , :default => false
      t.datetime  :confirmed_at
      t.timestamps
    end
  end
end
