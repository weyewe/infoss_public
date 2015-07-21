# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150713043707) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft",                                                        null: false
    t.integer  "rgt",                                                        null: false
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.boolean  "is_contra_account",                          default: false
    t.integer  "depth"
    t.integer  "normal_balance",                             default: 1
    t.integer  "account_case",                               default: 2
    t.boolean  "is_base_account",                            default: false
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "action_assignments", force: true do |t|
    t.integer  "user_id"
    t.integer  "action_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "actions", force: true do |t|
    t.integer  "section_id"
    t.string   "name"
    t.string   "action_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_administration_details", force: true do |t|
    t.integer  "bank_administration_id"
    t.integer  "account_id"
    t.string   "code"
    t.string   "description"
    t.integer  "status"
    t.decimal  "amount",                 precision: 14, scale: 2, default: 0.0
    t.boolean  "is_legacy",                                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bank_administrations", force: true do |t|
    t.integer  "cash_bank_id"
    t.datetime "administration_date"
    t.string   "code"
    t.string   "no_bukti"
    t.decimal  "amount",               precision: 14, scale: 2,  default: 0.0
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.integer  "exchange_rate_id"
    t.string   "description"
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batch_instances", force: true do |t|
    t.integer  "item_id"
    t.string   "name"
    t.text     "description"
    t.datetime "manufactured_at"
    t.decimal  "amount",                 precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "total_allocated_amount", precision: 14, scale: 2, default: 0.0
  end

  create_table "batch_source_allocations", force: true do |t|
    t.integer  "batch_source_id"
    t.integer  "batch_instance_id"
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.integer  "status",                                     default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batch_sources", force: true do |t|
    t.integer  "item_id"
    t.integer  "status",                                      default: 1
    t.string   "source_class"
    t.integer  "source_id"
    t.datetime "generated_date"
    t.decimal  "amount",             precision: 14, scale: 2, default: 0.0
    t.decimal  "unallocated_amount", precision: 14, scale: 2, default: 0.0
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "batch_stock_mutations", force: true do |t|
    t.integer  "item_id"
    t.integer  "status",                                     default: 1
    t.string   "source_class"
    t.integer  "source_id"
    t.datetime "mutation_date"
    t.text     "description"
    t.integer  "batch_instance_id"
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blanket_order_detail_usages", force: true do |t|
    t.integer  "blanket_order_detail_id"
    t.integer  "roll_blanket_batch_instance_id"
    t.decimal  "used_amount",                    precision: 14, scale: 2, default: 0.0
    t.decimal  "defect_amount",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "cut_amount",                     precision: 14, scale: 2, default: 0.0
    t.decimal  "reject_amount",                  precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blanket_order_details", force: true do |t|
    t.integer  "blanket_order_id"
    t.integer  "blanket_id"
    t.decimal  "total_cost",                  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_cut",                                               default: false
    t.boolean  "is_side_sealed",                                       default: false
    t.boolean  "is_bar_prepared",                                      default: false
    t.boolean  "is_adhesive_tape_applied",                             default: false
    t.boolean  "is_bar_mounted",                                       default: false
    t.boolean  "is_bar_heat_pressed",                                  default: false
    t.boolean  "is_bar_pull_off_tested",                               default: false
    t.boolean  "is_qc_and_marked",                                     default: false
    t.boolean  "is_packaged",                                          default: false
    t.boolean  "is_rejected",                                          default: false
    t.datetime "rejected_date"
    t.boolean  "is_job_scheduled",                                     default: false
    t.boolean  "is_finished",                                          default: false
    t.datetime "finished_at"
    t.decimal  "bar_cost",                    precision: 14, scale: 2, default: 0.0
    t.decimal  "adhesive_cost",               precision: 14, scale: 2, default: 0.0
    t.decimal  "roll_blanket_cost",           precision: 14, scale: 2, default: 0.0
    t.decimal  "roll_blanket_usage",          precision: 14, scale: 2, default: 0.0
    t.decimal  "roll_blanket_defect",         precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "quantity"
    t.integer  "finished_quantity"
    t.integer  "rejected_quantity"
    t.integer  "undelivered_quantity"
    t.decimal  "roll_blanket_defect_cost",    precision: 14, scale: 2, default: 0.0
    t.decimal  "finished_blanket_total_cost", precision: 14, scale: 2, default: 0.0
    t.decimal  "rejected_blanket_total_cost", precision: 14, scale: 2, default: 0.0
  end

  create_table "blanket_orders", force: true do |t|
    t.integer  "contact_id"
    t.integer  "warehouse_id"
    t.string   "code"
    t.integer  "amount_received"
    t.integer  "amount_rejected"
    t.integer  "amount_final"
    t.string   "production_no"
    t.datetime "order_date"
    t.text     "notes"
    t.boolean  "is_confirmed",    default: false
    t.boolean  "is_completed",    default: false
    t.boolean  "has_due_date",    default: false
    t.datetime "confirmed_at"
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blanket_warehouse_mutation_details", force: true do |t|
    t.integer  "blanket_warehouse_mutation_id"
    t.integer  "blanket_order_detail_id"
    t.string   "code"
    t.integer  "item_id"
    t.integer  "quantity",                      default: 0
    t.boolean  "is_confirmed",                  default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blanket_warehouse_mutations", force: true do |t|
    t.integer  "blanket_order_id"
    t.string   "code"
    t.integer  "warehouse_from_id"
    t.integer  "warehouse_to_id"
    t.datetime "mutation_date"
    t.boolean  "is_confirmed",      default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blankets", force: true do |t|
    t.string   "roll_no"
    t.integer  "contact_id"
    t.integer  "machine_id"
    t.integer  "adhesive_id"
    t.integer  "adhesive2_id"
    t.integer  "roll_blanket_item_id"
    t.integer  "left_bar_item_id"
    t.integer  "right_bar_item_id"
    t.decimal  "ac",                   precision: 14, scale: 2, default: 0.0
    t.decimal  "ar",                   precision: 14, scale: 2, default: 0.0
    t.decimal  "thickness",            precision: 14, scale: 2, default: 0.0
    t.decimal  "ks",                   precision: 14, scale: 2, default: 0.0
    t.boolean  "is_bar_required",                               default: false
    t.boolean  "has_left_bar",                                  default: false
    t.boolean  "has_right_bar",                                 default: false
    t.integer  "cropping_type",                                 default: 1
    t.decimal  "left_over_ac",         precision: 14, scale: 2, default: 0.0
    t.decimal  "left_over_ar",         precision: 14, scale: 2, default: 0.0
    t.decimal  "special",              precision: 14, scale: 2, default: 0.0
    t.integer  "application_case",                              default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blending_recipe_details", force: true do |t|
    t.integer  "blending_recipe_id"
    t.integer  "item_id"
    t.decimal  "amount",             precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blending_recipes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "target_item_id"
    t.decimal  "target_amount",  precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "blending_work_orders", force: true do |t|
    t.string   "code"
    t.integer  "blending_recipe_id"
    t.text     "description"
    t.datetime "blending_date"
    t.integer  "warehouse_id"
    t.boolean  "is_confirmed",       default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_bank_adjustments", force: true do |t|
    t.integer  "cash_bank_id"
    t.decimal  "amount",               precision: 14, scale: 2,  default: 0.0
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.integer  "exchange_rate_id"
    t.integer  "status",                                         default: 1
    t.datetime "adjustment_date"
    t.datetime "confirmed_at"
    t.boolean  "is_confirmed",                                   default: false
    t.text     "description"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_bank_mutations", force: true do |t|
    t.integer  "target_cash_bank_id"
    t.integer  "source_cash_bank_id"
    t.decimal  "amount",               precision: 14, scale: 2,  default: 0.0
    t.datetime "mutation_date"
    t.boolean  "is_confirmed",                                   default: false
    t.text     "description"
    t.datetime "confirmed_at"
    t.string   "no_bukti"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_banks", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "exchange_id"
    t.text     "description"
    t.boolean  "is_bank",                              default: true
    t.decimal  "amount",      precision: 14, scale: 2, default: 0.0
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_mutations", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.decimal  "amount",        precision: 14, scale: 2, default: 0.0
    t.integer  "status",                                 default: 1
    t.datetime "mutation_date"
    t.integer  "cash_bank_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "closing_details", force: true do |t|
    t.integer  "closing_id"
    t.integer  "exchange_id"
    t.decimal  "rate",        precision: 18, scale: 11, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "closings", force: true do |t|
    t.integer  "period"
    t.integer  "year_period"
    t.datetime "beginning_period"
    t.datetime "end_date_period"
    t.boolean  "is_year_closing",  default: false
    t.boolean  "is_closed",        default: false
    t.datetime "closed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compound_underlayer_usages", force: true do |t|
    t.integer  "recovery_order_detail_id"
    t.decimal  "defect_amount",            precision: 14, scale: 2, default: 0.0
    t.decimal  "finish_amount",            precision: 14, scale: 2, default: 0.0
    t.decimal  "reject_amount",            precision: 14, scale: 2, default: 0.0
    t.integer  "batch_instance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compound_usages", force: true do |t|
    t.integer  "recovery_order_detail_id"
    t.decimal  "defect_amount",            precision: 14, scale: 2, default: 0.0
    t.decimal  "finish_amount",            precision: 14, scale: 2, default: 0.0
    t.decimal  "reject_amount",            precision: 14, scale: 2, default: 0.0
    t.integer  "batch_instance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_groups", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.text     "delivery_address"
    t.text     "description"
    t.string   "nama"
    t.string   "npwp"
    t.string   "contact_no"
    t.string   "pic"
    t.string   "pic_contact_no"
    t.string   "email"
    t.boolean  "is_taxable"
    t.string   "tax_code"
    t.string   "contact_type"
    t.integer  "default_payment_term"
    t.string   "nama_faktur_pajak"
    t.integer  "contact_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "core_builders", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "base_sku"
    t.string   "sku_used_core"
    t.string   "sku_new_core"
    t.integer  "used_core_item_id"
    t.integer  "new_core_item_id"
    t.integer  "uom_id"
    t.integer  "machine_id"
    t.string   "core_builder_type_case"
    t.decimal  "cd",                     precision: 14, scale: 2, default: 0.0
    t.decimal  "tl",                     precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cores", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_items", force: true do |t|
    t.integer  "contact_id"
    t.integer  "warehouse_item_id"
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.decimal  "virtual",           precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_stock_adjustment_details", force: true do |t|
    t.integer  "customer_stock_adjustment_id"
    t.integer  "item_id"
    t.string   "code"
    t.integer  "status",                                                default: 1
    t.decimal  "amount",                       precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                        precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_stock_adjustments", force: true do |t|
    t.integer  "warehouse_id"
    t.integer  "contact_id"
    t.datetime "adjustment_date"
    t.text     "description"
    t.string   "code"
    t.decimal  "total",           precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                             default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customer_stock_mutations", force: true do |t|
    t.integer  "item_id"
    t.integer  "contact_id"
    t.integer  "customer_item_id"
    t.integer  "warehouse_id"
    t.integer  "warehouse_item_id"
    t.integer  "item_case"
    t.integer  "status",                                     default: 1
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.datetime "mutation_date"
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_order_details", force: true do |t|
    t.string   "code"
    t.integer  "order_type"
    t.string   "order_code"
    t.integer  "delivery_order_id"
    t.integer  "sales_order_detail_id"
    t.integer  "item_id"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "cogs",                    precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_invoiced_amount", precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_invoiced",                                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delivery_orders", force: true do |t|
    t.string   "code"
    t.integer  "sales_order_id"
    t.datetime "delivery_date"
    t.integer  "warehouse_id"
    t.string   "nomor_surat"
    t.decimal  "total_cogs",           precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_confirmed",                                   default: false
    t.boolean  "is_invoice_completed",                           default: false
    t.datetime "confirmed_at"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.text     "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "contact_no"
    t.string   "email"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchange_rates", force: true do |t|
    t.integer  "exchange_id"
    t.datetime "ex_rate_date"
    t.decimal  "rate",         precision: 18, scale: 11, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exchanges", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "account_payable_id"
    t.integer  "account_receivable_id"
    t.integer  "gbch_payable_id"
    t.integer  "gbch_receivable_id"
    t.boolean  "is_base",               default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "source_id"
    t.string   "source_class"
    t.string   "source_code"
    t.string   "code"
    t.integer  "home_id"
    t.decimal  "amount",       precision: 14, scale: 2, default: 0.0
    t.datetime "due_date"
    t.datetime "invoice_date"
    t.text     "description"
    t.boolean  "is_confirmed",                          default: false
    t.datetime "confirmed_at"
    t.boolean  "is_deleted",                            default: false
    t.datetime "deleted_at"
    t.boolean  "is_paid",                               default: false
    t.datetime "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "sku"
    t.boolean  "is_legacy",   default: false
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_batched",  default: false
  end

  create_table "items", force: true do |t|
    t.integer  "actable_id"
    t.string   "actable_type"
    t.integer  "item_type_id"
    t.string   "sku"
    t.string   "name"
    t.string   "description"
    t.boolean  "is_tradeable",                                default: false
    t.integer  "uom_id"
    t.decimal  "amount",             precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_delivery",   precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_receival",   precision: 14, scale: 2, default: 0.0
    t.decimal  "virtual",            precision: 14, scale: 2, default: 0.0
    t.decimal  "minimum_amount",     precision: 14, scale: 2, default: 0.0
    t.decimal  "customer_amount",    precision: 14, scale: 2, default: 0.0
    t.decimal  "selling_price",      precision: 14, scale: 2, default: 0.0
    t.integer  "exchange_id"
    t.integer  "price_mutation_id"
    t.decimal  "avg_price",          precision: 14, scale: 2, default: 0.0
    t.decimal  "customer_avg_price", precision: 14, scale: 2, default: 0.0
    t.decimal  "price_list",         precision: 14, scale: 2, default: 0.0
    t.integer  "sub_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "machines", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memorial_details", force: true do |t|
    t.integer  "memorial_id"
    t.integer  "account_id"
    t.string   "code"
    t.integer  "status"
    t.decimal  "amount",      precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memorials", force: true do |t|
    t.string   "code"
    t.string   "no_bukti"
    t.decimal  "amount",       precision: 14, scale: 2, default: 0.0
    t.string   "description"
    t.boolean  "is_confirmed",                          default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payables", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.integer  "contact_id"
    t.decimal  "amount",                   precision: 14, scale: 2,  default: 0.0
    t.decimal  "remaining_amount",         precision: 14, scale: 2,  default: 0.0
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount",     precision: 18, scale: 11, default: 0.0
    t.datetime "due_date"
    t.decimal  "pending_clearence_amount", precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_completed",                                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_request_details", force: true do |t|
    t.integer  "payment_request_id"
    t.integer  "account_id"
    t.integer  "status",                                      default: 1
    t.decimal  "amount",             precision: 14, scale: 2, default: 0.0
    t.boolean  "is_legacy",                                   default: false
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_requests", force: true do |t|
    t.integer  "contact_id"
    t.string   "no_bukti"
    t.datetime "request_date"
    t.string   "code"
    t.integer  "account_id"
    t.integer  "exchange_id"
    t.text     "description"
    t.decimal  "amount",               precision: 14, scale: 2,  default: 0.0
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.datetime "due_date"
    t.integer  "exchange_rate_id"
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_voucher_details", force: true do |t|
    t.integer  "payment_voucher_id"
    t.decimal  "amount",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "amount_paid",        precision: 14, scale: 2,  default: 0.0
    t.decimal  "pph_21",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "pph_23",             precision: 14, scale: 2,  default: 0.0
    t.integer  "payable_id"
    t.decimal  "rate",               precision: 18, scale: 11, default: 0.0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_vouchers", force: true do |t|
    t.string   "code"
    t.integer  "contact_id"
    t.integer  "cash_bank_id"
    t.integer  "status_pembulatan"
    t.datetime "payment_date"
    t.decimal  "amount",              precision: 14, scale: 2,  default: 0.0
    t.decimal  "rate_to_idr",         precision: 18, scale: 11, default: 0.0
    t.decimal  "total_pph_23",        precision: 18, scale: 11, default: 0.0
    t.decimal  "total_pph_21",        precision: 18, scale: 11, default: 0.0
    t.decimal  "biaya_bank",          precision: 18, scale: 11, default: 0.0
    t.decimal  "pembulatan",          precision: 18, scale: 11, default: 0.0
    t.string   "no_bukti"
    t.string   "gbch_no"
    t.boolean  "is_gbch",                                       default: false
    t.boolean  "is_reconciled",                                 default: false
    t.datetime "reconciliation_date"
    t.datetime "due_date"
    t.boolean  "is_confirmed",                                  default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_down_payment_allocation_details", force: true do |t|
    t.integer  "purchase_down_payment_allocation_id"
    t.integer  "payable_id"
    t.string   "code"
    t.decimal  "amount",                              precision: 14, scale: 2,  default: 0.0
    t.decimal  "amount_paid",                         precision: 14, scale: 2,  default: 0.0
    t.decimal  "rate",                                precision: 18, scale: 11, default: 0.0
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_down_payment_allocations", force: true do |t|
    t.integer  "contact_id"
    t.integer  "receivable_id"
    t.string   "code"
    t.datetime "allocation_date"
    t.decimal  "total_amount",    precision: 14, scale: 2,  default: 0.0
    t.decimal  "rate_to_idr",     precision: 18, scale: 11, default: 0.0
    t.boolean  "is_confirmed",                              default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_down_payments", force: true do |t|
    t.integer  "contact_id"
    t.integer  "receivable_id"
    t.integer  "payable_id"
    t.string   "code"
    t.datetime "down_payment_date"
    t.datetime "due_date"
    t.integer  "exchange_id"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 14, scale: 2, default: 0.0
    t.decimal  "total_amount",         precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                                  default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_invoice_details", force: true do |t|
    t.integer  "purchase_invoice_id"
    t.integer  "purchase_receival_detail_id"
    t.string   "code"
    t.decimal  "amount",                      precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                       precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_invoice_migrations", force: true do |t|
    t.string   "nomor_surat"
    t.integer  "contact_id"
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.decimal  "amount_payable",       precision: 14, scale: 2,  default: 0.0
    t.decimal  "tax",                  precision: 14, scale: 2,  default: 0.0
    t.decimal  "dpp",                  precision: 14, scale: 2,  default: 0.0
    t.datetime "invoice_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_invoices", force: true do |t|
    t.integer  "purchase_receival_id"
    t.string   "description"
    t.string   "code"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.integer  "exchange_rate_id"
    t.decimal  "amount_payable",       precision: 14, scale: 2,  default: 0.0
    t.decimal  "discount",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "tax",                  precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_taxable",                                     default: false
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmed_at"
    t.datetime "invoice_date"
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_order_details", force: true do |t|
    t.string   "code"
    t.integer  "purchase_order_id"
    t.integer  "item_id"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                   precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_received",                                  default: false
    t.decimal  "pending_receival_amount", precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_orders", force: true do |t|
    t.string   "code"
    t.integer  "contact_id"
    t.datetime "purchase_date"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.boolean  "is_receival_completed", default: false
    t.text     "description"
    t.boolean  "allow_edit_detail",     default: false
    t.boolean  "is_confirmed",          default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_receival_details", force: true do |t|
    t.string   "code"
    t.integer  "purchase_receival_id"
    t.integer  "purchase_order_detail_id"
    t.integer  "item_id"
    t.decimal  "amount",                   precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_invoiced_amount",  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_invoiced",                                   default: false
    t.decimal  "cogs",                     precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_receivals", force: true do |t|
    t.string   "code"
    t.integer  "purchase_order_id"
    t.datetime "receival_date"
    t.integer  "warehouse_id"
    t.string   "nomor_surat"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.decimal  "total_cogs",           precision: 14, scale: 2,  default: 0.0
    t.decimal  "total_amount",         precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmed_at"
    t.boolean  "is_invoice_completed",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipt_voucher_details", force: true do |t|
    t.integer  "receipt_voucher_id"
    t.decimal  "amount",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "amount_paid",        precision: 14, scale: 2,  default: 0.0
    t.decimal  "pph_23",             precision: 14, scale: 2,  default: 0.0
    t.integer  "receivable_id"
    t.decimal  "rate",               precision: 18, scale: 11, default: 0.0
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipt_vouchers", force: true do |t|
    t.string   "code"
    t.integer  "contact_id"
    t.integer  "cash_bank_id"
    t.integer  "status_pembulatan"
    t.datetime "receipt_date"
    t.decimal  "amount",              precision: 14, scale: 2,  default: 0.0
    t.decimal  "rate_to_idr",         precision: 18, scale: 11, default: 0.0
    t.decimal  "total_pph_23",        precision: 18, scale: 11, default: 0.0
    t.decimal  "biaya_bank",          precision: 18, scale: 11, default: 0.0
    t.decimal  "pembulatan",          precision: 18, scale: 11, default: 0.0
    t.string   "no_bukti"
    t.string   "gbch_no"
    t.boolean  "is_gbch",                                       default: false
    t.boolean  "is_reconciled",                                 default: false
    t.datetime "reconciliation_date"
    t.datetime "due_date"
    t.boolean  "is_confirmed",                                  default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receivables", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.integer  "contact_id"
    t.decimal  "amount",                   precision: 14, scale: 2,  default: 0.0
    t.decimal  "remaining_amount",         precision: 14, scale: 2,  default: 0.0
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount",     precision: 18, scale: 11, default: 0.0
    t.datetime "due_date"
    t.decimal  "pending_clearence_amount", precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_completed",                                       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recovery_accessory_details", force: true do |t|
    t.integer  "recovery_order_detail_id"
    t.integer  "item_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recovery_order_details", force: true do |t|
    t.integer  "recovery_order_id"
    t.integer  "roller_identification_form_detail_id"
    t.integer  "roller_builder_id"
    t.decimal  "total_cost",                           precision: 14, scale: 2, default: 0.0
    t.decimal  "compound_usage",                       precision: 14, scale: 2, default: 0.0
    t.string   "core_type_case",                                                default: "R"
    t.boolean  "is_disassembled",                                               default: false
    t.boolean  "is_stripped_and_glued",                                         default: false
    t.boolean  "is_wrapped",                                                    default: false
    t.boolean  "is_vulcanized",                                                 default: false
    t.boolean  "is_faced_off",                                                  default: false
    t.boolean  "is_conventional_grinded",                                       default: false
    t.boolean  "is_cnc_grinded",                                                default: false
    t.boolean  "is_polished_and_gc",                                            default: false
    t.boolean  "is_packaged",                                                   default: false
    t.boolean  "is_rejected",                                                   default: false
    t.datetime "rejected_date"
    t.boolean  "is_finished",                                                   default: false
    t.datetime "finished_date"
    t.decimal  "accessories_cost",                     precision: 14, scale: 2, default: 0.0
    t.decimal  "core_cost",                            precision: 14, scale: 2, default: 0.0
    t.decimal  "compound_cost",                        precision: 14, scale: 2, default: 0.0
    t.integer  "compound_under_layer_id"
    t.decimal  "compound_under_layer_usage",           precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recovery_orders", force: true do |t|
    t.integer  "roller_identification_form_id"
    t.integer  "warehouse_id"
    t.string   "code"
    t.integer  "amount_received",               default: 0
    t.integer  "amount_rejected",               default: 0
    t.integer  "amount_final",                  default: 0
    t.boolean  "is_completed",                  default: false
    t.boolean  "is_confirmed",                  default: false
    t.datetime "confirmed_at"
    t.boolean  "has_due_date",                  default: false
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.json     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roll_blanket_usages", force: true do |t|
    t.integer  "blanket_order_detail_id"
    t.decimal  "defect_amount",           precision: 14, scale: 2, default: 0.0
    t.decimal  "finish_amount",           precision: 14, scale: 2, default: 0.0
    t.decimal  "reject_amount",           precision: 14, scale: 2, default: 0.0
    t.integer  "batch_instance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roller_accessory_details", force: true do |t|
    t.integer  "roller_identification_form_detail_id"
    t.integer  "item_id"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roller_builders", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "base_sku"
    t.string   "sku_roller_used_core"
    t.string   "sku_roller_new_core"
    t.integer  "roller_used_core_item_id"
    t.integer  "roller_new_core_item_id"
    t.integer  "uom_id"
    t.integer  "adhesive_id"
    t.integer  "machine_id"
    t.integer  "roller_type_id"
    t.integer  "compound_id"
    t.integer  "core_builder_id"
    t.boolean  "is_crowning",                                       default: false
    t.boolean  "is_grooving",                                       default: false
    t.boolean  "is_chamfer",                                        default: false
    t.decimal  "crowning_size",            precision: 14, scale: 2, default: 0.0
    t.decimal  "grooving_width",           precision: 14, scale: 2, default: 0.0
    t.decimal  "grooving_depth",           precision: 14, scale: 2, default: 0.0
    t.decimal  "grooving_position",        precision: 14, scale: 2, default: 0.0
    t.decimal  "rd",                       precision: 14, scale: 2, default: 0.0
    t.decimal  "cd",                       precision: 14, scale: 2, default: 0.0
    t.decimal  "rl",                       precision: 14, scale: 2, default: 0.0
    t.decimal  "wl",                       precision: 14, scale: 2, default: 0.0
    t.decimal  "tl",                       precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roller_identification_form_details", force: true do |t|
    t.integer  "roller_identification_form_id"
    t.integer  "detail_id"
    t.integer  "material_case"
    t.integer  "core_builder_id"
    t.integer  "roller_type_id"
    t.integer  "machine_id"
    t.integer  "repair_request_case"
    t.decimal  "rd",                            precision: 14, scale: 2, default: 0.0
    t.decimal  "cd",                            precision: 14, scale: 2, default: 0.0
    t.decimal  "rl",                            precision: 14, scale: 2, default: 0.0
    t.decimal  "wl",                            precision: 14, scale: 2, default: 0.0
    t.decimal  "tl",                            precision: 14, scale: 2, default: 0.0
    t.boolean  "is_job_scheduled",                                       default: false
    t.boolean  "is_delivered",                                           default: false
    t.boolean  "is_roller_built",                                        default: false
    t.boolean  "is_confirmed",                                           default: false
    t.datetime "confirmed_at"
    t.string   "roller_no"
    t.decimal  "gl",                            precision: 14, scale: 2, default: 0.0
    t.decimal  "groove_length",                 precision: 14, scale: 2, default: 0.0
    t.decimal  "groove_amount",                 precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roller_identification_forms", force: true do |t|
    t.string   "code"
    t.integer  "warehouse_id"
    t.string   "nomor_disasembly"
    t.datetime "incoming_roll"
    t.integer  "contact_id"
    t.boolean  "is_in_house",      default: false
    t.integer  "amount"
    t.datetime "identified_date"
    t.boolean  "is_confirmed",     default: false
    t.datetime "confirmed_at"
    t.boolean  "is_completed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roller_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roller_warehouse_mutation_details", force: true do |t|
    t.integer  "roller_warehouse_mutation_id"
    t.integer  "recovery_order_detail_id"
    t.string   "code"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roller_warehouse_mutations", force: true do |t|
    t.integer  "recovery_order_id"
    t.string   "code"
    t.integer  "warehouse_from_id"
    t.integer  "warehouse_to_id"
    t.datetime "mutation_date"
    t.integer  "amount"
    t.boolean  "is_confirmed",      default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rollers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_down_payment_allocation_details", force: true do |t|
    t.integer  "sales_down_payment_allocation_id"
    t.integer  "receivable_id"
    t.string   "code"
    t.decimal  "amount",                           precision: 14, scale: 2,  default: 0.0
    t.decimal  "amount_paid",                      precision: 14, scale: 2,  default: 0.0
    t.decimal  "rate",                             precision: 18, scale: 11, default: 0.0
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_down_payment_allocations", force: true do |t|
    t.integer  "contact_id"
    t.integer  "payable_id"
    t.string   "code"
    t.datetime "allocation_date"
    t.decimal  "total_amount",    precision: 14, scale: 2,  default: 0.0
    t.decimal  "rate_to_idr",     precision: 18, scale: 11, default: 0.0
    t.boolean  "is_confirmed",                              default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_down_payments", force: true do |t|
    t.integer  "contact_id"
    t.integer  "receivable_id"
    t.integer  "payable_id"
    t.string   "code"
    t.datetime "down_payment_date"
    t.datetime "due_date"
    t.integer  "exchange_id"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 14, scale: 2, default: 0.0
    t.decimal  "total_amount",         precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                                  default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_invoice_details", force: true do |t|
    t.integer  "sales_invoice_id"
    t.integer  "delivery_order_detail_id"
    t.string   "code"
    t.decimal  "amount",                   precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                    precision: 14, scale: 2, default: 0.0
    t.decimal  "cos",                      precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_invoice_migrations", force: true do |t|
    t.string   "nomor_surat"
    t.integer  "contact_id"
    t.integer  "exchange_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.decimal  "amount_receivable",    precision: 14, scale: 2,  default: 0.0
    t.decimal  "tax",                  precision: 14, scale: 2,  default: 0.0
    t.decimal  "dpp",                  precision: 14, scale: 2,  default: 0.0
    t.datetime "invoice_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_invoices", force: true do |t|
    t.integer  "delivery_order_id"
    t.text     "description"
    t.string   "code"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.integer  "exchange_rate_id"
    t.decimal  "exchange_rate_amount", precision: 18, scale: 11, default: 0.0
    t.decimal  "total_cos",            precision: 14, scale: 2,  default: 0.0
    t.decimal  "amount_receivable",    precision: 14, scale: 2,  default: 0.0
    t.decimal  "discount",             precision: 14, scale: 2,  default: 0.0
    t.decimal  "dpp",                  precision: 14, scale: 2,  default: 0.0
    t.decimal  "tax",                  precision: 14, scale: 2,  default: 0.0
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "confirmed_at"
    t.datetime "invoice_date"
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_order_details", force: true do |t|
    t.string   "code"
    t.string   "order_code"
    t.integer  "sales_order_id"
    t.integer  "item_id"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_delivered",                                 default: false
    t.decimal  "pending_delivery_amount", precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                   precision: 14, scale: 2, default: 0.0
    t.boolean  "is_service",                                       default: false
    t.boolean  "is_confirmed",                                     default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sales_orders", force: true do |t|
    t.string   "code"
    t.integer  "order_type"
    t.string   "order_code"
    t.integer  "contact_id"
    t.integer  "employee_id"
    t.datetime "sales_date"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.boolean  "is_confirmed",          default: false
    t.boolean  "is_delivery_completed", default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sections", force: true do |t|
    t.string   "name"
    t.string   "controller_name"
    t.text     "description"
    t.integer  "position"
    t.string   "group_name"
    t.string   "tab"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_costs", force: true do |t|
    t.integer  "item_id"
    t.integer  "roller_builder_id"
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.decimal  "avg_price",         precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_adjustment_details", force: true do |t|
    t.integer  "stock_adjustment_id"
    t.integer  "item_id"
    t.string   "code"
    t.integer  "status",                                       default: 1
    t.decimal  "amount",              precision: 14, scale: 2, default: 0.0
    t.decimal  "price",               precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_adjustments", force: true do |t|
    t.integer  "warehouse_id"
    t.datetime "adjustment_date"
    t.text     "description"
    t.string   "code"
    t.decimal  "total",           precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                             default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stock_mutations", force: true do |t|
    t.integer  "item_id"
    t.integer  "warehouse_id"
    t.integer  "warehouse_item_id"
    t.integer  "item_case"
    t.integer  "status",                                     default: 1
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.datetime "mutation_date"
    t.decimal  "amount",            precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_types", force: true do |t|
    t.string   "name"
    t.integer  "item_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temporary_delivery_order_details", force: true do |t|
    t.string   "code"
    t.integer  "temporary_delivery_order_id"
    t.integer  "sales_order_detail_id"
    t.integer  "item_id"
    t.boolean  "is_reconciled",                                        default: false
    t.boolean  "is_all_completed",                                     default: false
    t.decimal  "amount",                      precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_cogs",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_amount",                precision: 14, scale: 2, default: 0.0
    t.decimal  "restock_amount",              precision: 14, scale: 2, default: 0.0
    t.decimal  "selling_price",               precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "temporary_delivery_orders", force: true do |t|
    t.string   "code"
    t.integer  "order_type"
    t.integer  "delivery_order_id"
    t.datetime "delivery_date"
    t.integer  "warehouse_id"
    t.string   "nomor_surat"
    t.decimal  "total_waste_cogs",      precision: 14, scale: 2, default: 0.0
    t.boolean  "is_delivery_completed",                          default: false
    t.boolean  "is_reconciled",                                  default: false
    t.boolean  "is_pushed",                                      default: false
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "push_date"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_data", force: true do |t|
    t.integer  "transaction_source_id"
    t.string   "transaction_source_type"
    t.datetime "transaction_datetime"
    t.text     "description"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed"
    t.integer  "code"
    t.boolean  "is_contra_transaction",                            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_data_details", force: true do |t|
    t.integer  "transaction_data_id"
    t.integer  "account_id"
    t.integer  "entry_case"
    t.decimal  "amount",              precision: 14, scale: 2, default: 0.0
    t.string   "description"
    t.boolean  "is_bank_transaction",                          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transaction_data_non_base_exchange_details", force: true do |t|
    t.integer  "transaction_data_detail_id"
    t.integer  "exchange_id"
    t.decimal  "amount",                     precision: 18, scale: 11, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uoms", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.string   "name"
    t.string   "username"
    t.string   "login"
    t.boolean  "is_deleted",             default: false
    t.boolean  "is_main_user",           default: false
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "valid_comb_income_statements", force: true do |t|
    t.integer  "account_id"
    t.integer  "closing_id"
    t.decimal  "amount",     precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "valid_comb_non_base_exchanges", force: true do |t|
    t.integer  "valid_comb_id"
    t.integer  "exchange_id"
    t.decimal  "amount",        precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "valid_combs", force: true do |t|
    t.integer  "account_id"
    t.integer  "closing_id"
    t.integer  "entry_case"
    t.decimal  "amount",     precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_delivery_order_details", force: true do |t|
    t.string   "code"
    t.integer  "virtual_delivery_order_id"
    t.integer  "virtual_order_detail_id"
    t.integer  "item_id"
    t.boolean  "is_reconciled",                                      default: false
    t.boolean  "is_all_completed",                                   default: false
    t.decimal  "amount",                    precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_cogs",                precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_amount",              precision: 14, scale: 2, default: 0.0
    t.decimal  "restock_amount",            precision: 14, scale: 2, default: 0.0
    t.decimal  "selling_price",             precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_delivery_orders", force: true do |t|
    t.string   "code"
    t.integer  "order_type"
    t.integer  "virtual_order_id"
    t.datetime "delivery_date"
    t.integer  "warehouse_id"
    t.string   "nomor_surat"
    t.decimal  "total_waste_cogs",      precision: 14, scale: 2, default: 0.0
    t.boolean  "is_delivery_completed",                          default: false
    t.boolean  "is_reconciled",                                  default: false
    t.boolean  "is_pushed",                                      default: false
    t.boolean  "is_confirmed",                                   default: false
    t.datetime "push_date"
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_order_clearance_details", force: true do |t|
    t.string   "code"
    t.integer  "virtual_order_clearance_id"
    t.integer  "virtual_delivery_order_detail_id"
    t.decimal  "amount",                           precision: 14, scale: 2, default: 0.0
    t.decimal  "waste_cogs",                       precision: 14, scale: 2, default: 0.0
    t.decimal  "selling_price",                    precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_order_clearances", force: true do |t|
    t.string   "code"
    t.integer  "virtual_delivery_order_id"
    t.datetime "clearance_date"
    t.decimal  "total_waste_cogs",          precision: 14, scale: 2, default: 0.0
    t.boolean  "is_waste",                                           default: false
    t.boolean  "is_confirmed",                                       default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_order_details", force: true do |t|
    t.string   "code"
    t.integer  "virtual_order_id"
    t.integer  "item_id"
    t.decimal  "amount",                  precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_delivery_amount", precision: 14, scale: 2, default: 0.0
    t.decimal  "price",                   precision: 14, scale: 2, default: 0.0
    t.boolean  "is_all_delivered",                                 default: false
    t.boolean  "is_confirmed",                                     default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "virtual_orders", force: true do |t|
    t.string   "code"
    t.integer  "contact_id"
    t.integer  "employee_id"
    t.datetime "order_date"
    t.integer  "order_type"
    t.text     "description"
    t.string   "nomor_surat"
    t.integer  "exchange_id"
    t.boolean  "is_confirmed",          default: false
    t.datetime "confirmed_at"
    t.boolean  "is_delivery_completed", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouse_items", force: true do |t|
    t.integer  "warehouse_id"
    t.integer  "item_id"
    t.decimal  "amount",           precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_receival", precision: 14, scale: 2, default: 0.0
    t.decimal  "pending_delivery", precision: 14, scale: 2, default: 0.0
    t.decimal  "customer_amount",  precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouse_mutation_details", force: true do |t|
    t.integer  "warehouse_mutation_id"
    t.integer  "item_id"
    t.string   "code"
    t.decimal  "amount",                precision: 14, scale: 2, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouse_mutations", force: true do |t|
    t.integer  "warehouse_from_id"
    t.integer  "warehouse_to_id"
    t.datetime "mutation_date"
    t.text     "description"
    t.string   "code"
    t.boolean  "is_confirmed",      default: false
    t.datetime "confirmed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "warehouses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
