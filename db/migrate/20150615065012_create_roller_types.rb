class CreateRollerTypes < ActiveRecord::Migration
  def change
    create_table :roller_types do |t|
      t.string :name
      t.text  :description
      t.timestamps
    end
  end
end
