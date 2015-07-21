class CreateWarehouseMutations < ActiveRecord::Migration
  def change
    create_table :warehouse_mutations do |t|
      t.integer :warehouse_from_id
      t.integer :warehouse_to_id
      t.datetime :mutation_date
      t.text  :description
      t.string  :code
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
