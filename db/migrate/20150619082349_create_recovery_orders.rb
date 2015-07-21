class CreateRecoveryOrders < ActiveRecord::Migration
  def change
    create_table :recovery_orders do |t|
      t.integer :roller_identification_form_id
      t.integer :warehouse_id
      t.string :code
      t.integer :amount_received ,  :default => 0
      t.integer :amount_rejected ,  :default => 0
      t.integer :amount_final , :default => 0
      t.boolean :is_completed , :default => false
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.boolean :has_due_date , :default => false
      t.datetime :due_date
      t.timestamps
    end
  end
end
