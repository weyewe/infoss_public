class CreateClosingDetails < ActiveRecord::Migration
  def change
    create_table :closing_details do |t|
      t.integer :closing_id
      t.integer :exchange_id
      t.decimal :rate , :default          => 0,  :precision => 18, :scale => 11
      t.timestamps
    end
  end
end
