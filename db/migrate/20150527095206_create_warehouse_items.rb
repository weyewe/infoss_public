class CreateWarehouseItems < ActiveRecord::Migration
  def change
    create_table :warehouse_items do |t|
      t.integer :warehouse_id
      t.integer :item_id
      t.decimal :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :pending_receival, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :pending_delivery, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :customer_amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
