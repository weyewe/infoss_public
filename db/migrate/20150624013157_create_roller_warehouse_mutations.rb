class CreateRollerWarehouseMutations < ActiveRecord::Migration
  def change
    create_table :roller_warehouse_mutations do |t|
      t.integer :recovery_order_id
      t.string  :code
      t.integer :warehouse_from_id
      t.integer :warehouse_to_id
      t.datetime  :mutation_date
      t.integer :amount
      t.boolean :is_confirmed , :default => false
      t.datetime  :confirmed_at
      t.timestamps
    end
  end
end
