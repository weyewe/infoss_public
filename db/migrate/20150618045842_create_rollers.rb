class CreateRollers < ActiveRecord::Migration
  def change
    create_table :rollers do |t|
      
      t.timestamps
    end
  end
end
