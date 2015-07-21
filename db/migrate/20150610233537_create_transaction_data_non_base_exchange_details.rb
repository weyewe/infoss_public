class CreateTransactionDataNonBaseExchangeDetails < ActiveRecord::Migration
  def change
    create_table :transaction_data_non_base_exchange_details do |t|
      t.integer :transaction_data_detail_id
      t.integer :exchange_id
      t.decimal :amount ,:default => 0,  :precision => 18, :scale => 11
      
      t.timestamps
    end
  end
end
