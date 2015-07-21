class CreateBlankets < ActiveRecord::Migration
  def change
    create_table :blankets do |t|
    t.string :roll_no
    t.integer :contact_id
    t.integer :machine_id
    t.integer :adhesive_id
    t.integer :adhesive2_id
    t.integer :roll_blanket_item_id
    t.integer :left_bar_item_id
    t.integer :right_bar_item_id
    t.decimal :ac, :default        => 0,  :precision => 14, :scale => 2
    t.decimal :ar, :default        => 0,  :precision => 14, :scale => 2
    t.decimal :thickness, :default        => 0,  :precision => 14, :scale => 2
    t.decimal :ks, :default        => 0,  :precision => 14, :scale => 2
    t.boolean :is_bar_required ,:default => false      
    t.boolean :has_left_bar ,:default => false      
    t.boolean :has_right_bar ,:default => false      
    t.integer :cropping_type ,:default => CROPPING_TYPE[:normal] 
    t.decimal :left_over_ac, :default        => 0,  :precision => 14, :scale => 2
    t.decimal :left_over_ar, :default        => 0,  :precision => 14, :scale => 2
    t.decimal :special, :default        => 0,  :precision => 14, :scale => 2
    t.integer :application_case ,:default => APPLICATION_CASE[:sheetfed]
    t.timestamps
    end
  end
end
