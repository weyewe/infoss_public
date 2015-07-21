class CreateMemorialDetails < ActiveRecord::Migration
  def change
    create_table :memorial_details do |t|
      t.integer :memorial_id
      t.integer :account_id
      t.string  :code
      t.integer :status
      t.decimal :amount, :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
