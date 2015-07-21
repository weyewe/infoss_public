class CreateSalesOrderDetails < ActiveRecord::Migration
  def change
    create_table :sales_order_details do |t|

      t.string :code
      t.string  :order_code
      t.integer :sales_order_id
      t.integer :item_id
      t.decimal :amount,  :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_all_delivered , :default => false
      t.decimal :pending_delivery_amount,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :price,  :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_service , :default => false
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
