class CreateCustomerStockAdjustments < ActiveRecord::Migration
  def change
    create_table :customer_stock_adjustments do |t|
      t.integer :warehouse_id
      t.integer :contact_id
      t.datetime :adjustment_date
      t.text  :description
      t.string  :code
      t.decimal  :total, :default => 0 ,  :precision => 14, :scale => 2
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
