class CreatePaymentRequestDetails < ActiveRecord::Migration
  def change
    create_table :payment_request_details do |t|
      t.integer :payment_request_id
      t.integer :account_id
      t.integer :status ,:default        => STATUS_ACCOUNT[:debet]
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.boolean :is_legacy, :default => false
      t.string :code
      t.timestamps
    end
  end
end
