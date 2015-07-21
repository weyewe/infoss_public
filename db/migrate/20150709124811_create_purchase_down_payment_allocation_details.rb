class CreatePurchaseDownPaymentAllocationDetails < ActiveRecord::Migration
  def change
    create_table :purchase_down_payment_allocation_details do |t|
      t.integer :purchase_down_payment_allocation_id
      t.integer :payable_id
      t.string  :code
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :amount_paid , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :rate , :default        => 0,  :precision => 18, :scale => 11
      t.text  :description
      t.timestamps
    end
  end
end
