class CreateCoreBuilders < ActiveRecord::Migration
  def change
    create_table :core_builders do |t|
      t.string :name
      t.text :description
      t.string :base_sku
      t.string :sku_used_core
      t.string :sku_new_core
      t.integer :used_core_item_id
      t.integer :new_core_item_id
      t.integer :uom_id
      t.integer :machine_id
      t.string  :core_builder_type_case
      t.decimal :cd, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :tl, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
