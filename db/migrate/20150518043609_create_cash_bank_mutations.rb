class CreateCashBankMutations < ActiveRecord::Migration
  def change
    create_table :cash_bank_mutations do |t|
      t.integer :target_cash_bank_id
      t.integer :source_cash_bank_id
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2 
      t.datetime :mutation_date
      t.boolean :is_confirmed , :default => false
      t.text :description
      t.datetime  :confirmed_at
      t.string :no_bukti
      t.integer :exchange_rate_id
      t.decimal :exchange_rate_amount , :default        => 0,  :precision => 18, :scale => 11
      t.datetime :mutation_date
      t.string :code
      t.timestamps
    end
  end
end
