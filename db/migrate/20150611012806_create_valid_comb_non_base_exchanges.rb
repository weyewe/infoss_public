class CreateValidCombNonBaseExchanges < ActiveRecord::Migration
  def change
    create_table :valid_comb_non_base_exchanges do |t|
      t.integer :valid_comb_id
      t.integer :exchange_id
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
