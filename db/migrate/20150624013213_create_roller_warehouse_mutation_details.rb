class CreateRollerWarehouseMutationDetails < ActiveRecord::Migration
  def change
    create_table :roller_warehouse_mutation_details do |t|
      t.integer :roller_warehouse_mutation_id
      t.integer :recovery_order_detail_id
      t.string  :code
      t.integer :item_id
      t.timestamps
    end
  end
end
