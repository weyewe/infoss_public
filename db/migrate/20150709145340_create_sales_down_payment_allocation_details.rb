class CreateSalesDownPaymentAllocationDetails < ActiveRecord::Migration
  def change
    create_table :sales_down_payment_allocation_details do |t|
      t.integer :sales_down_payment_allocation_id
      t.integer :receivable_id
      t.string  :code
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :amount_paid , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :rate , :default        => 0,  :precision => 18, :scale => 11
      t.text  :description
      t.timestamps
    end
  end
end
