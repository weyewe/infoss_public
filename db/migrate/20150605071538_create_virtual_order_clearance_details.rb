class CreateVirtualOrderClearanceDetails < ActiveRecord::Migration
  def change
    create_table :virtual_order_clearance_details do |t|
      t.string :code
      t.integer :virtual_order_clearance_id
      t.integer :virtual_delivery_order_detail_id
      t.decimal :amount,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :waste_cogs,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :selling_price,  :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
