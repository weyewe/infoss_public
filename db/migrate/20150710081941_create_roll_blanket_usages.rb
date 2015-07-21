class CreateRollBlanketUsages < ActiveRecord::Migration
  def change
    create_table :roll_blanket_usages do |t|
      
      t.integer :blanket_order_detail_id 
      t.decimal :defect_amount, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :finish_amount, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :reject_amount, :default        => 0,  :precision => 14, :scale => 2
      t.integer :batch_instance_id 
      

      t.timestamps
    end
  end
end
