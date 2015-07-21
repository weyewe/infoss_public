class CreatePurchaseReceivalDetails < ActiveRecord::Migration
  def change
    create_table :purchase_receival_details do |t|
      t.string :code
      t.integer :purchase_receival_id
      t.integer :purchase_order_detail_id
      t.integer :item_id
      t.decimal :amount, :default => 0,  :precision => 14, :scale => 2
      t.decimal :pending_invoiced_amount, :default => 0 ,  :precision => 14, :scale => 2
      t.boolean :is_all_invoiced, :default => false
      t.decimal :cogs, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
