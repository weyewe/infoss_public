class CreateSalesDownPayments < ActiveRecord::Migration
  def change
    create_table :sales_down_payments do |t|
      t.integer :contact_id
      t.integer :receivable_id
      t.integer :payable_id
      t.string  :code
      t.datetime :down_payment_date
      t.datetime :due_date
      t.integer :exchange_id
      t.integer :exchange_rate_id
      t.decimal :exchange_rate_amount,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :total_amount,  :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
