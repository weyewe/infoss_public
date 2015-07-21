class CreateWarehouseMutationDetails < ActiveRecord::Migration
  def change
    create_table :warehouse_mutation_details do |t|
      t.integer :warehouse_mutation_id
      t.integer :item_id
      t.string  :code
      t.decimal  :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
