class CreateBankAdministrations < ActiveRecord::Migration
  def change
    create_table :bank_administrations do |t|
      t.integer :cash_bank_id
      t.datetime :administration_date
      t.string  :code
      t.string  :no_bukti
      t.decimal :amount,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :exchange_rate_amount, :default => 0,  :precision => 18, :scale => 11
      t.integer :exchange_rate_id
      t.string  :description
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
