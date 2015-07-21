class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.text   :address
      t.string  :contact_no
      t.string  :email
      t.text  :description
      t.timestamps
    end
  end
end
