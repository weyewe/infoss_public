class CreatePurchaseInvoiceDetails < ActiveRecord::Migration
  def change
    create_table :purchase_invoice_details do |t|
      
      t.integer :purchase_invoice_id
      t.integer :purchase_receival_detail_id
      t.string :code
      t.decimal :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :price, :default => 0 , :default => 0,  :precision => 14, :scale => 2  
      t.timestamps
    end
  end
end
