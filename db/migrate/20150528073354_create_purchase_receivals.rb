class CreatePurchaseReceivals < ActiveRecord::Migration
  def change
    create_table :purchase_receivals do |t|
      t.string :code
      t.integer :purchase_order_id
      t.datetime :receival_date
      t.integer :warehouse_id
      t.string :nomor_surat
      t.integer :exchange_rate_id
      t.decimal :exchange_rate_amount, :default => 0 , :default => 0,  :precision => 18, :scale => 11
      t.decimal :total_cogs, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :total_amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.boolean :is_invoice_completed , :default => false
      t.timestamps
    end
  end
end
