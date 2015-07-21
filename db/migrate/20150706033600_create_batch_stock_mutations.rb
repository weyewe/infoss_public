class CreateBatchStockMutations < ActiveRecord::Migration
  def change
    create_table :batch_stock_mutations do |t|

      t.integer :item_id
     
      t.integer :status , :default        => ADJUSTMENT_STATUS[:addition] 
      
      t.string  :source_class
      t.integer :source_id 
      t.datetime :mutation_date
      
      t.text :description 
      
      t.integer :batch_instance_id
       
      
      
      t.decimal :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      
      t.timestamps
    end
  end
end
