class CreatePaymentVoucherDetails < ActiveRecord::Migration
  def change
    create_table :payment_voucher_details do |t|
      t.integer :payment_voucher_id
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2 
      t.decimal :amount_paid , :default   => 0,  :precision => 14, :scale => 2 
      t.decimal :pph_21 , :default        => 0,  :precision => 14, :scale => 2 
      t.decimal :pph_23 , :default        => 0,  :precision => 14, :scale => 2 
      t.integer :payable_id
      t.decimal :rate , :default          => 0,  :precision => 18, :scale => 11
      t.string :description
      t.timestamps
    end
  end
end
