class CreateRollerIdentificationFormDetails < ActiveRecord::Migration
  def change
    create_table :roller_identification_form_details do |t|
      t.integer :roller_identification_form_id
      t.integer :detail_id
      t.integer :material_case
      t.integer :core_builder_id
      t.integer :roller_type_id
      t.integer :machine_id
      t.integer :repair_request_case
      t.decimal :rd,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :cd,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :rl,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :wl,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :tl,  :default => 0,  :precision => 14, :scale => 2
      t.boolean :is_job_scheduled , :default => false
      t.boolean :is_delivered , :default => false
      t.boolean :is_roller_built , :default => false
      t.boolean :is_confirmed , :default => false
      t.datetime :confirmed_at
      t.string :roller_no
      t.decimal :gl,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :groove_length,  :default => 0,  :precision => 14, :scale => 2
      t.decimal :groove_amount,  :default => 0,  :precision => 14, :scale => 2
      t.timestamps
    end
  end
end
