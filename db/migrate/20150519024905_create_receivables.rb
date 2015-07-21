class CreateReceivables < ActiveRecord::Migration
  def change
    create_table :receivables do |t|
      t.string  :source_class
      t.integer :source_id
      t.string  :source_code
      t.integer :contact_id
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2
      t.decimal :remaining_amount , :default        => 0,  :precision => 14, :scale => 2
      t.integer :exchange_id
      t.decimal :exchange_rate_amount, :default => 0 , :default => 0,  :precision => 18, :scale => 11
      t.datetime :due_date
      t.decimal :pending_clearence_amount , :default        => 0,  :precision => 14, :scale => 2
      t.boolean :is_completed , :default => false
      t.timestamps
    end
  end
end
