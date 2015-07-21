class CreateRecoveryAccessoryDetails < ActiveRecord::Migration
  def change
    create_table :recovery_accessory_details do |t|
      t.integer :recovery_order_detail_id
      t.integer :item_id
      t.integer :amount
      t.timestamps
    end
  end
end
