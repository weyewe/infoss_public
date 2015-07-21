class CreateBatchSourceAllocations < ActiveRecord::Migration
  def change
    create_table :batch_source_allocations do |t|
      
      t.integer :batch_source_id
      t.integer :batch_instance_id 
      
      t.decimal :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.integer :status , :default => ADJUSTMENT_STATUS[:addition]
      

      t.timestamps
    end
  end
end
