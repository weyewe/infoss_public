class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.integer :parent_id, :null => true, :index => true
      t.integer :lft, :null => false, :index => true
      t.integer :rgt, :null => false, :index => true
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.boolean :is_contra_account, :default => false 
      t.integer :depth
      t.integer :normal_balance , :default => NORMAL_BALANCE[:debit]
      
      t.integer :account_case , :default => ACCOUNT_CASE[:ledger]
      
      t.boolean :is_base_account, :default => false 
      
      t.string :code
      t.timestamps
    end
  end
end
