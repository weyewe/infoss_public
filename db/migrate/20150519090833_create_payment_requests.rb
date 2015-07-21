 class CreatePaymentRequests < ActiveRecord::Migration
  def change
    create_table :payment_requests do |t|      
      t.integer :contact_id
      t.string :no_bukti
      t.datetime :request_date
      t.string :code
      t.integer :account_id
      t.integer :exchange_id
      t.text :description 
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :exchange_rate_amount , :default        => 0,  :precision => 18, :scale => 11
      t.datetime :due_date
      t.integer :exchange_rate_id
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
