class CreatePurchaseInvoices < ActiveRecord::Migration
  def change
    create_table :purchase_invoices do |t|
      
      t.integer :purchase_receival_id
      t.string :description
      t.string :code
      t.string :nomor_surat
      t.integer :exchange_id
      t.decimal :exchange_rate_amount, :default => 0,  :precision => 18, :scale => 11
      t.integer :exchange_rate_id
      t.decimal :amount_payable,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :discount,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :tax, :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_taxable , :default => false
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.datetime :invoice_date
      t.datetime :due_date
      t.timestamps
    end
  end
end
