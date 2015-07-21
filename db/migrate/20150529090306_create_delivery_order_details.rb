class CreateDeliveryOrderDetails < ActiveRecord::Migration
  def change
    create_table :delivery_order_details do |t|
      t.string :code
      t.integer :order_type
      t.string  :order_code
      t.integer :delivery_order_id
      t.integer :sales_order_detail_id
      t.integer :item_id
      t.decimal :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :cogs, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :pending_invoiced_amount, :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_all_invoiced , :default =>false
      t.timestamps
    end
  end
end
