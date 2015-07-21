class CreateExchangeRates < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.integer :exchange_id
      t.datetime :ex_rate_date
      t.decimal :rate ,:default=> 0,  :precision => 18, :scale => 11
      t.timestamps
    end
  end
end
