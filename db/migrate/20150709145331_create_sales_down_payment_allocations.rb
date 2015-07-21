class CreateSalesDownPaymentAllocations < ActiveRecord::Migration
  def change
    create_table :sales_down_payment_allocations do |t|
      t.integer :contact_id
      t.integer :payable_id
      t.string  :code
      t.datetime  :allocation_date
      t.decimal :total_amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :rate_to_idr , :default        => 0,  :precision => 18, :scale => 11
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at      
      t.timestamps
    end
  end
end
