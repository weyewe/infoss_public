class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.text   :address
      t.text   :delivery_address
      t.text   :description
      t.string :nama
      t.string :npwp
      t.string :contact_no
      t.string :pic
      t.string :pic_contact_no
      t.string :email
      t.boolean :is_taxable
      t.string :tax_code
      t.string :contact_type
      t.integer :default_payment_term
      t.string :nama_faktur_pajak
      t.integer :contact_group_id
      t.timestamps
    end
  end
end
