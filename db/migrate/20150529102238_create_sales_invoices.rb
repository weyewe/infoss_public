class CreateSalesInvoices < ActiveRecord::Migration
  def change
    create_table :sales_invoices do |t|
      t.integer :delivery_order_id
      t.text :description
      t.string :code
      t.string :nomor_surat
      t.integer :exchange_id
      t.integer :exchange_rate_id
      t.decimal :exchange_rate_amount, :default => 0,  :precision => 18, :scale => 11
      t.decimal :total_cos, :default => 0,  :precision => 14, :scale => 2
      t.decimal :amount_receivable,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :discount,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :dpp,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :tax, :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.datetime :invoice_date
      t.datetime :due_date
      t.timestamps
    end
  end
end
