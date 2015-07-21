class CreateTemporaryDeliveryOrderDetails < ActiveRecord::Migration
  def change
    create_table :temporary_delivery_order_details do |t|
      t.string :code
      t.integer :temporary_delivery_order_id
      t.integer :sales_order_detail_id
      t.integer :item_id
      t.boolean :is_reconciled , :default => false
      t.boolean :is_all_completed , :default => false
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :waste_cogs , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :waste_amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :restock_amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :selling_price , :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
