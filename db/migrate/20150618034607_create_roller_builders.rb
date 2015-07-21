class CreateRollerBuilders < ActiveRecord::Migration
  def change
    create_table :roller_builders do |t|
      t.string :name
      t.text :description
      t.string :base_sku
      t.string :sku_roller_used_core
      t.string :sku_roller_new_core
      t.integer :roller_used_core_item_id
      t.integer :roller_new_core_item_id
      t.integer :uom_id
      t.integer :adhesive_id
      t.integer :machine_id
      t.integer :roller_type_id
      t.integer :compound_id
      t.integer :core_builder_id
      t.boolean :is_crowning ,:default => false
      t.boolean :is_grooving ,:default => false
      t.boolean :is_chamfer ,:default => false
      t.decimal :crowning_size, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :grooving_width, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :grooving_depth, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :grooving_position, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :rd, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :cd, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :rl, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :wl, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :tl, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
