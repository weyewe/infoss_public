class AddTotalAllocatedToBatchInstance < ActiveRecord::Migration
  def change
    
    add_column :batch_instances,  :total_allocated_amount , :decimal, :default        => 0,  :precision => 14, :scale => 2
  end
end
