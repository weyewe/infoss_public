class CreateRollerAccessoryDetails < ActiveRecord::Migration
  def change
    create_table :roller_accessory_details do |t|
      t.integer :roller_identification_form_detail_id
      t.integer :item_id
      t.integer :amount
      t.timestamps
    end
  end
end
