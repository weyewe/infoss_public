class CreateServiceCosts < ActiveRecord::Migration
  def change
    create_table :service_costs do |t|
      t.integer :item_id
      t.integer :roller_builder_id
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :avg_price, :default     => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
