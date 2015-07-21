class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer :section_id 
      t.string :name 
      t.string :action_name 

      t.timestamps
    end
  end
end
