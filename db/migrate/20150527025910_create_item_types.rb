class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name
      t.text :description
      t.string :sku
      t.boolean :is_legacy , :default => false
      t.integer :account_id
      t.timestamps
    end
  end
end
