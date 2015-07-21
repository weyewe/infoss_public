class CreateVirtualDeliveryOrders < ActiveRecord::Migration
  def change
    create_table :virtual_delivery_orders do |t|
      t.string :code
      t.integer :order_type
      t.integer :virtual_order_id
      t.datetime :delivery_date
      t.integer :warehouse_id
      t.string  :nomor_surat
      t.decimal :total_waste_cogs , :default        => 0,  :precision => 14, :scale => 2
      t.boolean :is_delivery_completed , :default => false
      t.boolean :is_reconciled , :default => false
      t.boolean :is_pushed , :default => false
      t.boolean :is_confirmed , :default => false
      t.datetime :push_date 
      t.datetime :confirmed_at 
      t.timestamps
    end
  end
end
