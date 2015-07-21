class CreateValidCombIncomeStatements < ActiveRecord::Migration
  def change
    create_table :valid_comb_income_statements do |t|
      t.integer :account_id
      t.integer :closing_id
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
