class CreatePurchaseInvoiceMigrations < ActiveRecord::Migration
  def change
    create_table :purchase_invoice_migrations do |t|
      t.string :nomor_surat
      t.integer :contact_id
      t.integer :exchange_id
      t.decimal :exchange_rate_amount, :default => 0,  :precision => 18, :scale => 11
      t.decimal :amount_payable,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :tax, :default => 0,  :precision => 14, :scale => 2
      t.decimal :dpp, :default => 0,  :precision => 14, :scale => 2
      t.datetime  :invoice_date
      t.timestamps
    end
  end
end
