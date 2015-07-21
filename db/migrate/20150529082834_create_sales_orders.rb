class CreateSalesOrders < ActiveRecord::Migration
  def change
    create_table :sales_orders do |t|      
      t.string :code
      t.integer :order_type
      t.string :order_code
      t.integer  :contact_id
      t.integer  :employee_id
      t.datetime :sales_date
      t.string  :nomor_surat
      t.integer :exchange_id
      t.boolean :is_confirmed , :default => false
      t.boolean :is_delivery_completed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
