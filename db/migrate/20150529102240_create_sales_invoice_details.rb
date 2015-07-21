class CreateSalesInvoiceDetails < ActiveRecord::Migration
  def change
    create_table :sales_invoice_details do |t|
      t.integer :sales_invoice_id
      t.integer :delivery_order_detail_id
      t.string :code
      t.decimal :amount, :default => 0 , :default => 0,  :precision => 14, :scale => 2
      t.decimal :price, :default => 0 , :default => 0,  :precision => 14, :scale => 2  
      t.decimal :cos, :default => 0 , :default => 0,  :precision => 14, :scale => 2  
      t.timestamps
    end
  end
end
