class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|     
      t.actable
      t.integer :item_type_id
      t.string :sku
      t.string :name
      t.string :description
      t.boolean :is_tradeable , :default => false
      t.integer :uom_id
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :pending_delivery, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :pending_receival, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :virtual, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :minimum_amount, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :customer_amount, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :selling_price, :default        => 0,  :precision => 14, :scale => 2
      t.integer :exchange_id
      t.integer :price_mutation_id
      t.decimal :avg_price, :default => 0 , :precision => 14,:scale =>2
      t.decimal :customer_avg_price, :default => 0 , :precision => 14,:scale =>2
      t.decimal :price_list, :default => 0 , :precision => 14,:scale =>2
      t.integer :sub_type_id
      t.timestamps
    end
  end
end
