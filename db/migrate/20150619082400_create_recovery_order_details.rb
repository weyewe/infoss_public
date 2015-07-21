class CreateRecoveryOrderDetails < ActiveRecord::Migration
  def change
    create_table :recovery_order_details do |t|
      t.integer :recovery_order_id
      t.integer :roller_identification_form_detail_id
      t.integer :roller_builder_id
      t.decimal :total_cost,  :default => 0,  :precision => 14, :scale => 2 
      t.decimal :compound_usage,  :default => 0,  :precision => 14, :scale => 2 
      t.string  :core_type_case , :default => CORE_TYPE_CASE[:r]
      t.boolean :is_disassembled , :default => false
      t.boolean :is_stripped_and_glued , :default => false
      t.boolean :is_wrapped , :default => false
      t.boolean :is_vulcanized , :default => false
      t.boolean :is_faced_off , :default => false
      t.boolean :is_conventional_grinded , :default => false
      t.boolean :is_cnc_grinded , :default => false
      t.boolean :is_polished_and_gc , :default => false
      t.boolean :is_packaged , :default => false
      t.boolean :is_rejected , :default => false
      t.datetime :rejected_date
      t.boolean :is_finished , :default => false
      t.datetime :finished_date
      t.decimal :accessories_cost,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :core_cost,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :compound_cost,  :default => 0,  :precision => 14, :scale => 2
      t.integer :compound_under_layer_id
      t.decimal :compound_under_layer_usage,  :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
