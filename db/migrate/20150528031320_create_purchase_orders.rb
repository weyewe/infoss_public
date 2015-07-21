class CreatePurchaseOrders < ActiveRecord::Migration
  def change
    create_table :purchase_orders do |t|
      t.string :code
      t.integer :contact_id
      t.datetime :purchase_date
      t.string :nomor_surat
      t.integer :exchange_id
      t.boolean :is_receival_completed , :default => false
      t.text :description
      t.boolean :allow_edit_detail , :default => false
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
