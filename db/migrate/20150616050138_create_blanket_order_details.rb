class CreateBlanketOrderDetails < ActiveRecord::Migration
  def change
    create_table :blanket_order_details do |t|
      t.integer :blanket_order_id
      t.integer :blanket_id
      t.decimal :total_cost, :default        => 0,  :precision => 14, :scale => 2
      t.boolean :is_cut , :default => false
      t.boolean :is_side_sealed , :default => false
      t.boolean :is_bar_prepared , :default => false
      t.boolean :is_adhesive_tape_applied , :default => false
      t.boolean :is_bar_mounted , :default => false
      t.boolean :is_bar_heat_pressed , :default => false
      t.boolean :is_bar_pull_off_tested , :default => false
      t.boolean :is_qc_and_marked , :default => false
      t.boolean :is_packaged , :default => false
      t.boolean :is_rejected , :default => false
      t.datetime  :rejected_date
	    t.boolean :is_job_scheduled , :default => false
	    t.boolean :is_finished , :default => false
      t.datetime :finished_at
      t.decimal :bar_cost, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :adhesive_cost, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :roll_blanket_cost, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :roll_blanket_usage, :default        => 0,  :precision => 14, :scale => 2
      t.decimal :roll_blanket_defect, :default        => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
