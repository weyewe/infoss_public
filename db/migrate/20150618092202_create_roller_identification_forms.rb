class CreateRollerIdentificationForms < ActiveRecord::Migration
  def change
    create_table :roller_identification_forms do |t|
      t.string :code
      t.integer :warehouse_id
      t.string  :nomor_disasembly
      t.datetime  :incoming_roll
      t.integer :contact_id
      t.boolean :is_in_house , :default => false
      t.integer :amount
      t.datetime  :identified_date
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.boolean :is_completed , :default => false
      t.timestamps
    end
  end
end
