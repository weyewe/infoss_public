class CreateActionAssignments < ActiveRecord::Migration
  def change
    create_table :action_assignments do |t|
      t.integer :user_id
      t.integer :action_id 
      
      

      t.timestamps
    end
  end
end
