class CreateStockMutations < ActiveRecord::Migration
  def change
    create_table :stock_mutations do |t|
      t.integer :item_id
      t.integer :warehouse_id
      t.integer :warehouse_item_id
      t.integer :item_case
      t.integer :status , :default        => ADJUSTMENT_STATUS[:addition] 
      t.string  :source_class
      t.integer :source_id
      t.string  :source_code
      t.datetime :mutation_date
      t.decimal :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
