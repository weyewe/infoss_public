class CreateBlendingWorkOrders < ActiveRecord::Migration
  def change
    create_table :blending_work_orders do |t|
	    t.string :code
	    t.integer :blending_recipe_id
	    t.text :description
	    t.datetime :blending_date
	    t.integer :warehouse_id
	    t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
