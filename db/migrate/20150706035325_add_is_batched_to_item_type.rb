class AddIsBatchedToItemType < ActiveRecord::Migration
  def change
    add_column :item_types, :is_batched, :boolean, :default => false 
  end
end
