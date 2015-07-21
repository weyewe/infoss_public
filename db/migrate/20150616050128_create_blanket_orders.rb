class CreateBlanketOrders < ActiveRecord::Migration
  def change
    create_table :blanket_orders do |t|
      t.integer :contact_id
      t.integer :warehouse_id
      t.string  :code
      t.integer :amount_received
      t.integer :amount_rejected
      t.integer :amount_final
      t.string  :production_no
      t.datetime  :order_date
      t.text  :notes
      t.boolean :is_confirmed , :default => false
      t.boolean :is_completed , :default => false
      t.boolean :has_due_date , :default => false
      t.datetime  :confirmed_at
      t.datetime  :due_date
      t.timestamps
    end
  end
end
