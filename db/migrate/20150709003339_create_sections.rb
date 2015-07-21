class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      
      t.string :name 
      t.string :controller_name 
      t.text :description 
      
      t.integer :position 
      t.string :group_name 
      t.string :tab 

      t.timestamps
    end
  end
end
