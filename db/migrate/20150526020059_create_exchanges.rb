class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :name
      t.text :description
      t.integer :account_payable_id
      t.integer :account_receivable_id
      t.integer :gbch_payable_id
      t.integer :gbch_receivable_id
      t.boolean :is_base, :default => false 
      t.timestamps
    end
  end
end
