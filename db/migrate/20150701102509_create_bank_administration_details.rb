class CreateBankAdministrationDetails < ActiveRecord::Migration
  def change
    create_table :bank_administration_details do |t|
      t.integer :bank_administration_id
      t.integer :account_id
      t.string  :code
      t.string  :description
      t.integer :status
      t.decimal :amount, :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_legacy , :default => false
      t.timestamps
    end
  end
end
