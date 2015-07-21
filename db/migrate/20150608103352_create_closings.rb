class CreateClosings < ActiveRecord::Migration
  def change
    create_table :closings do |t|
      t.integer :period
      t.integer :year_period
      t.datetime :beginning_period
      t.datetime :end_date_period
      t.boolean :is_year_closing , :default        => false
      t.boolean :is_closed , :default        => false
      t.datetime :closed_at
      t.timestamps
    end
  end
end
