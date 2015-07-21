class CreateBlendingRecipes < ActiveRecord::Migration
  def change
    create_table :blending_recipes do |t|
      t.string :name
      t.text :description
      t.integer :target_item_id
      t.decimal :target_amount, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
