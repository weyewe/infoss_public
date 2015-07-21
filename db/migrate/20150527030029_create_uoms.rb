class CreateUoms < ActiveRecord::Migration
  def change
    create_table :uoms do |t|
      t.string :name
      t.timestamps
    end
  end
end
