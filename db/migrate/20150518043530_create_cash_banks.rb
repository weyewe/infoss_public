class CreateCashBanks < ActiveRecord::Migration
  def change
    create_table :cash_banks do |t|
      t.string :name
      t.string :code
      t.integer :exchange_id
      t.text :description
      t.boolean :is_bank, :default => true  
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2 
      t.integer :account_id
      t.timestamps
    end
  end
end
