class AddQuantityToBlanketOrderDetail < ActiveRecord::Migration
  def change
    add_column :blanket_order_details, :quantity , :integer 
    add_column :blanket_order_details, :finished_quantity , :integer 
    add_column :blanket_order_details, :rejected_quantity , :integer 
    add_column :blanket_order_details, :undelivered_quantity  , :integer 
    add_column :blanket_order_details,  :roll_blanket_defect_cost, :decimal, :default        => 0,  :precision => 14, :scale => 2
    add_column :blanket_order_details,  :finished_blanket_total_cost , :decimal, :default        => 0,  :precision => 14, :scale => 2
    add_column :blanket_order_details,  :rejected_blanket_total_cost, :decimal, :default        => 0,  :precision => 14, :scale => 2
    
    
  end
end
