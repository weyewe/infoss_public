class CreatePaymentVouchers < ActiveRecord::Migration
  def change
    create_table :payment_vouchers do |t|
      t.string :code 
      t.integer :contact_id
      t.integer :cash_bank_id
      t.integer :status_pembulatan
      t.datetime :payment_date
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2 
      t.decimal :rate_to_idr , :default        => 0,  :precision => 18, :scale => 11
      t.decimal :total_pph_23 , :default        => 0,  :precision => 18, :scale => 11
      t.decimal :total_pph_21 , :default        => 0,  :precision => 18, :scale => 11
      t.decimal :biaya_bank , :default        => 0,  :precision => 18, :scale => 11
      t.decimal :pembulatan , :default        => 0,  :precision => 18, :scale => 11
      t.string :no_bukti
      t.string :gbch_no
      t.boolean :is_gbch , :default => false
      t.boolean :is_reconciled , :default => false
      t.datetime :reconciliation_date 
      t.datetime :due_date 
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at 
      t.timestamps
    end
  end
end
