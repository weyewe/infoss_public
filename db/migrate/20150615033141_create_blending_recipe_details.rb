class CreateBlendingRecipeDetails < ActiveRecord::Migration
  def change
    create_table :blending_recipe_details do |t|
      t.integer :blending_recipe_id
      t.integer :item_id
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end

