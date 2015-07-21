class CreateCustomerItems < ActiveRecord::Migration
  def change
    create_table :customer_items do |t|
      t.integer :contact_id
      t.integer :warehouse_item_id
      t.decimal :amount, :default => 0,  :precision => 14, :scale => 2
      t.decimal :virtual, :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
