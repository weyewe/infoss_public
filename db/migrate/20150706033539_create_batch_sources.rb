class CreateBatchSources < ActiveRecord::Migration
  def change
    create_table :batch_sources do |t|

      t.integer :item_id 
      t.integer :status , :default        =>  ADJUSTMENT_STATUS[:addition] 
      t.string  :source_class
      t.integer :source_id 
      t.datetime :generated_date 
      t.decimal :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :unallocated_amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.text :description 
      
      t.timestamps
    end
  end
end
