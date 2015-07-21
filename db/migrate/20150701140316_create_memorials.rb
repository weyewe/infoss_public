class CreateMemorials < ActiveRecord::Migration
  def change
    create_table :memorials do |t|
      t.string  :code
      t.string  :no_bukti
      t.decimal :amount,  :default => 0,  :precision => 14, :scale => 2
      t.string  :description
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.timestamps
    end
  end
end
