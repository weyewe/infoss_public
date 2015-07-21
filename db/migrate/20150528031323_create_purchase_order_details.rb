class CreatePurchaseOrderDetails < ActiveRecord::Migration
  def change
    create_table :purchase_order_details do |t|

      t.string   :code
      t.integer  :purchase_order_id
      t.integer  :item_id
      t.decimal  :amount, :default =>0  ,:precision => 14, :scale => 2
      t.decimal  :price, :default =>0  ,:precision => 14, :scale => 2
      t.boolean  :is_all_received, :default => false
      t.decimal  :pending_receival_amount ,:default=> 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
