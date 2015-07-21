class CreateBlanketOrderDetailUsages < ActiveRecord::Migration
  def change
    create_table :blanket_order_detail_usages do |t|
      t.integer :blanket_order_detail_id 
      
      t.integer :roll_blanket_batch_instance_id
      
      t.decimal :used_amount, :default        => 0,  :precision => 14, :scale => 2  # for a given roll blanket, how many meters are used
      t.decimal :defect_amount, :default        => 0,  :precision => 14, :scale => 2  # how many meters of the blanket that can't be used
      t.decimal :cut_amount, :default        => 0,  :precision => 14, :scale => 2 # number of blankets finished  (with the bar)
      t.decimal :reject_amount, :default        => 0,  :precision => 14, :scale => 2  # number of blankets rejected (with the bar) 

      t.timestamps
    end
  end
end
