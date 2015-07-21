ROLE_NAME = {
  :admin => "admin",
  :manager => "manager",
  :data_entry => "dataentry"
}

 

# => TIMEZONE ( for 1 store deployment. For multitenant => different story) 
UTC_OFFSET = 7 
LOCAL_TIME_ZONE = "Jakarta" 

EXT_41_JS = 'https://s3.amazonaws.com/weyewe-extjs/41/ext-all.js'

EXTENSIBLE = 'https://s3.amazonaws.com/weyewe-extjs/extensible-all.js'

VIEW_VALUE = {
  :week => 0, 
  :month => 1, 
  :year => 2 
}
 

IMAGE_ASSET_URL = {
  
  # MSG BOX
  :alert => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/alert.png',
  :background => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/background.png',
  :confirm => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/confirm.png',
  :error => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/error.png',
  :info => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/info.png',
  :question => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/question.png',
  :success => 'http://s3.amazonaws.com/salmod/app_asset/msg-box/success.png',
  
  
  # FONT 
  :font_awesome_eot => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.eot',
  :font_awesome_svg => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.svg',
  :font_awesome_svgz =>'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.svgz',
  :font_awesome_ttf => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.ttf',
  :font_awesome_woff => 'http://s3.amazonaws.com/salmod/app_asset/font/fontawesome-webfont.woff',  
  
  
  # BOOTSTRAP SPECIFIC 
  :glyphicons_halflings_white => 'http://s3.amazonaws.com/salmod/app_asset/bootstrap/glyphicons-halflings-white.png',
  :glyphicons_halflings_black => 'http://s3.amazonaws.com/salmod/app_asset/bootstrap/glyphicons-halflings.png',
  
  # jquery UI-lightness 
  :ui_bg_diagonal_thick_18 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_diagonals-thick_18_b81900_40x40.png',
  :ui_bg_diagonal_thick_20 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_diagonals-thick_20_666666_40x40.png',
  :ui_bg_flat_10 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_flat_10_000000_40x100.png' , 
  :ui_bg_glass_100_f6f6f6 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_100_f6f6f6_1x400.png',
  :ui_bg_glass_100 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_100_fdf5ce_1x400.png',
  :ui_bg_glass_65 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_glass_65_ffffff_1x400.png',
  :ui_bf_gloss_wave => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_gloss-wave_35_f6a828_500x100.png',
  :ui_bg_highlight_soft_100 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_gloss-wave_35_f6a828_500x100.png',
  :ui_bg_highlight_soft_75 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_highlight-soft_75_ffe45c_1x100.png',
  :ui_icons_222222 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_222222_256x240.png',
  :ui_icons_228ef1 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_228ef1_256x240.png',
  :ui_icons_ef8c08 => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ef8c08_256x240.png',
  :ui_icons_ffd27a => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ffd27a_256x240.png',
  :ui_icons_ffffff => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-icons_ffffff_256x240.png',
  :ui_bg_highlight_soft_100_eeeeee => 'http://s3.amazonaws.com/salmod/app_asset/jquery-ui/ui-bg_highlight-soft_100_eeeeee_1x100.png',
  
  
  # APP_APPLICATION.css 
  :jquery_handle => 'http://s3.amazonaws.com/salmod/app_asset/app_application/handle.png',
  :jquery_handle_vertical => 'http://s3.amazonaws.com/salmod/app_asset/app_application/handle-vertical.png',
  :login_bg => 'http://s3.amazonaws.com/salmod/app_asset/app_application/login-bg.png',
  :user_signin => 'http://s3.amazonaws.com/salmod/app_asset/app_application/user.png',
  :password => 'http://s3.amazonaws.com/salmod/app_asset/app_application/password.png',
  :password_error => 'http://s3.amazonaws.com/salmod/app_asset/app_application/password_error.png',
  :check_signin => 'http://s3.amazonaws.com/salmod/app_asset/app_application/check.png',
  :twitter => 'http://s3.amazonaws.com/salmod/app_asset/app_application/twitter_btn.png',
  :fb_button => 'http://s3.amazonaws.com/salmod/app_asset/app_application/fb_btn.png',
  :validation_error => 'http://s3.amazonaws.com/salmod/app_asset/app_application/validation-error.png',
  :validation_success => 'http://s3.amazonaws.com/salmod/app_asset/app_application/validation-success.png',
  :zoom => 'http://s3.amazonaws.com/salmod/app_asset/app_application/zoom.png',
  :logo => 'http://s3.amazonaws.com/salmod/app_asset/app_application/logo.png' 
}

# Application Specific 
REVISION_STATUS = {
  :base => 0,
  :major => 1,
  :minor => 2 
}

CLEARANCE_STATUS = {
  :approved =>1 ,
  :rejected => 2 
}

USER_JOB_STATUS = {
  :observer => 1 , 
  :worker => 2 
}

MAINTENANCE_CASE ={
  :scheduled => 1, 
  :emergency => 2 
}


DIAGNOSIS_CASE = {
  :all_ok => 1 ,
  :require_fix => 2,
  :require_replacement => 3  
}

SOLUTION_CASE = {
  :normal => 1 ,
  :pending => 2,
  :solved =>  3    # 
}

ADJUSTMENT_STATUS = {
  :addition => 1, 
  :deduction => 2 
}

TAX_CODE = {
  :code_01 => "01",
  :code_02 => "02",
  :code_03 => "03",
  :code_04 => "04",
  :code_05 => "05",
  :code_06 => "06",
  :code_07 => "07",
  :code_08 => "08",
  :code_09 => "09",
  }

TAX_VALUE = {
  :code_01 => 10,
  :code_02 => 10,
  :code_03 => 10,
  :code_04 => 1,
  :code_05 => 10,
  :code_06 => 10,
  :code_07 => 0,
  :code_08 => 0,
  :code_09 => 0,
  }

CONTACT_TYPE = {
  :customer => 1,
  :supplier => 2,
  }

ITEM_CASE = {
  :ready => 1,
  :pending_receival => 2,
  :pending_delivery => 3,
  :virtual => 4 
  }

ITEM_TYPE_CASE = {
  :Accessory => "Accessory",	
  :AdhesiveBlanket => "AdhesiveBlanket",
  :AdhesiveRoller => "AdhesiveRoller",
  :Bar => "Bar",
  :Blanket => "Blanket",
  :Bearing => "Bearing",
  :RollBlanket => "RollBlanket",
  :Chemical => "Chemical",
  :Compound => "Compound",
  :Consumable => "Consumable",
  :Core => "Core",
  :Glue => "Glue",
  :Underpacking => "Underpacking",
  :Roller => "Roller",
  }


STATUS_ACCOUNT = {
  :debet => 1,
  :credit => 2,
  }

STATUS_PEMBULATAN = {
  :debet => 1,
  :credit => 2,
  }

CROPPING_TYPE = {
  :normal => 1,
  :special => 2,
  :none => 3 
}

APPLICATION_CASE = {
  :sheetfed => 1,
  :web => 2,
  :both => 3
}

ORDER_TYPE_CASE = {		
  :trial_order => 0,	
  :sample_order => 1,
  :consignment => 2,	
  :part_delivery_order => 3,	
  :sales_order => 4,	
  :sales_quotation => 5,		
  }		

CORE_TYPE_CASE = {
  :r => "R",
  :z => "Z"
}

CORE_BUILDER_TYPE = {		
  :hollow => "Hollow",	
  :shaft => "Shaft",
  :none => "None"
  }	


MATERIAL_CASE ={
  :new => 1,
  :used => 2
  }
  
REPAIR_REQUEST_CASE ={
  :bearing_set => 1,
  :centre_drill => 2,
  :none => 3,
  :bearing_set_and_centre_drill => 4,
  :repair_corosive => 5,
  :bearing_set_and_repair_corosive => 6,
  :centre_drill_and_repair_corosive =>7,
  :all => 8,
  }



BASE_JS_APP = "#{Dir.pwd}/app/assets/javascripts/app"
 

BASE_CONTROLLER_FOLDER = "#{Dir.pwd}/app/controllers"

BASE_MASTER_TEMPLATE_FOLDER = "#{Dir.pwd}/lib/tasks/master"
BASE_MASTER_DETAIL_TEMPLATE_FOLDER = "#{Dir.pwd}/lib/tasks/masterdetail"



BASE_RESULT_FOLDER = "#{Dir.pwd}/lib/tasks/result"


WickedPdf.config = {
  exe_path: '/usr/local/bin/wkhtmltopdf'
}


MIGRATION_FILENAME = {
  :contact_group => 'ContactGroup.csv',
  :contact =>  'Contact.csv',
  :user => 'UserAccounts.csv',
  :employee => 'Employees.csv',
  :item_type => 'ItemTypes.csv',
  :sub_type => 'SubTypes.csv',
  :core_builder => "CoreBuilders.csv",
  :roller_type => "RollerTypes.csv",
  :roller_builder => "RollerBuilders.csv",
  :blanket => "Blankets.csv",
  :machine => "Machines.csv",
  :uom => 'UoMs.csv',
  :item => "Items.csv",
  :warehouse => 'Warehouses.csv',
  :cash_bank => "CashBanks.csv",
  :exchange => "Currencies.csv",
  :coa => 'Accounts.csv',
  
  :exchange_rate => "ExchangeRates.csv",
  :stock_adjustment => "StockAdjustments.csv", 
  :stock_adjustment_detail => "StockAdjustmentDetails.csv",
  :stock_adjustment_confirm => "StockAdjustmentConfirm.csv",
  
  :sales_order => "SalesOrders.csv",
  :sales_order_detail => "SalesOrderDetails.csv",
  :sales_order_confirm => "SalesOrderConfirm.csv",
  
  :delivery_order => "DeliveryOrders.csv",
  :delivery_order_detail => "DeliveryOrderDetails.csv",
  :delivery_order_confirm => "DeliveryOrderConfirm.csv",
  
  :sales_invoice => "SalesInvoices.csv",
  :sales_invoice_detail => "SalesInvoiceDetails.csv",
  :sales_invoice_confirm => "SalesInvoiceConfirm.csv",
  
  :purchase_order => "PurchaseOrders.csv",
  :purchase_order_detail => "PurchaseOrderDetails.csv",
  :purchase_order_confirm => "PurchaseOrderConfirm.csv",
  
  :purchase_receival => "PurchaseReceivals.csv",
  :purchase_receival_detail => "PurchaseReceivalDetails.csv",
  :purchase_receival_confirm => "PurchaseReceivalConfirm.csv",
  
  :purchase_invoice => "PurchaseInvoices.csv",
  :purchase_invoice_detail => "PurchaseInvoiceDetails.csv",
  :purchase_invoice_confirm => "PurchaseInvoiceConfirm.csv",
  
  :roller_identification_form => "CoreIdentifications.csv",
  :roller_identification_form_detail => "CoreIdentificationDetails.csv",
  :roller_identification_form_confirm => "CoreIdentificationConfirm.csv",
  
  :recovery_order  => "RecoveryOrders.csv",
  :recovery_order_detail => "RecoveryOrderDetails.csv",
  :recovery_order_confirm => "RecoveryOrderConfirm.csv",
  :recovery_accessory_detail => "RecoveryAccessoryDetails.csv",
  :recovery_detail_finish_reject => "RecoveryDetailFinishReject.csv",
  
  :blanket_order  => "BlanketOrders.csv",
  :blanket_order_detail => "BlanketOrderDetails.csv",
  :blanket_order_confirm => "BlanketOrderConfirm.csv",
  :blanket_detail_finish_reject => "BlanketDetailFinishReject.csv",
  
  :payable => "Payables.csv",
  :receivable => "Receivables.csv",
  
  :outstanding_sales_invoice  => "SalesInvoiceMigrations.csv",
  :outstanding_purchase_invoice  => "PurchaseInvoiceMigrations.csv" ,
  
  :payment_request => "PaymentRequests.csv",
  :payment_request_detail => "PaymentRequestDetails.csv",
  :payment_request_confirm => "PaymentRequestConfirm.csv",
  
  :receipt_voucher => "ReceiptVouchers.csv",
  :receipt_voucher_detail => "ReceiptVoucherDetails.csv",
  :receipt_voucher_confirm => "ReceiptVoucherConfirm.csv",
  
  :payment_voucher => "PaymentVouchers.csv",
  :payment_voucher_detail => "PaymentVoucherDetails.csv",
  :payment_voucher_confirm => "PaymentVoucherConfirm.csv",
  
  
} 

BASE_ITEM_TYPE = {
  :accessory => "Accessory",
  :adhesive_blanket => "AdhesiveBlanket",
  :adhesive_roller => "AdhesiveRoller",
  :bar => "Bar",
  :blanket => "Blanket",
  :roll_blanket => "RollBlanket",
  :chemical => "Chemical",
  :compound => "Compound",
  :core => "Core",
  :underpacking => "Underpacking",
  :roller => "Roller"
  
} 

EXCHANGE_BASE_NAME = "Rupiah"
 
 
 
 
MENU_GROUP = {
  :master => "Master",
  :operation => "Operation"
}



 
MENU_ACTION_CONSTANT = {
  :system_setup_menu => {
    :nodes => [
          [ "api/app_users", true, "User"  ],
          [ "api/employees", true, "Employee" ],
          [ "api/passwords", true, "Password" ]
        ] ,
    :text => "System Setup" ,
    :group => MENU_GROUP[:master],
    :position => 1
  } ,
  :contact_menu => {
    :nodes => [ 
          [ "api/contact_groups", true, "Contact Group"  ], 
          [ "api/customers", true , "Customer"],
          [ "api/suppliers", true , "Supplier"] 
        ] ,
    :text => "Contact" ,
    :group => MENU_GROUP[:master],
    :position => 2
  } ,
  :inventory_menu => {
    :nodes => [
 
          [ "api/warehouses", true, "Warehouse"  ], 
          [ "api/item_types", true, "Item Type" ],
          [ "api/sub_types", true , "Sub Type"],
          [ "api/uoms", true , "UoM"],  
          [ "api/items", true , "Item"],  
          [ "api/roller_types", true, "Roller Type" ],   
 
        ] ,
    :text => "Inventory" ,
    :group => MENU_GROUP[:master],
    :position => 3
  } ,
  :manufacturing_item_menu => {
    :nodes => [ 
          [ "api/machines", true, "Machine"  ], 
          [ "api/core_builders", true , "Core Builder"],
          [ "api/roller_builders", true, "Roller Builder" ],
          [ "api/blankets", true, "Blanket" ],  
          [ "api/blending_recipes", false , "Blending Recipe" ],  
          [ "api/roller_types", true , "Roller Type"],    
        ] ,
    :text => "Manufacturing Item" ,
    :group => MENU_GROUP[:master] ,
    :position => 4
  } ,
  :finance_master_menu => {
    :nodes => [ 
          [ "api/cash_banks", true, "Cash Bank"  ], 
          [ "api/accounts", true , "CoA"],
          [ "api/exchanges", true , "Exchange" ],
          [ "api/exchange_rates", true, "Exchange Rate" ],  
        ] ,
    :text => "Finance" ,
    :group => MENU_GROUP[:master],
    :position =>5 
  } ,
  
  
  
  :logistic_menu => {
    :nodes => [ 
          [ "api/stock_adjustments", false , "Stock Adjustment" ], 
          [ "api/warehouse_mutations", false , "Mutasi Gudang" ]  
        ] ,
    :text => "Logistic" ,
    :group => MENU_GROUP[:operation],
    :position => 1
  } ,
  :batch_menu => {
    :nodes => [
         
          [ "api/batch_instances", true , "Batch" ], 
          [ "api/batch_source_allocations", true, "Alokasi Batch" ] 

        ] ,
    :text => "Batch" ,
    :group => MENU_GROUP[:operation],
    :position => 2
  } ,
  
 
  :manufacturing_menu => {
    :nodes => [
         
 

        ] ,
    :text => "Manufacturing" ,
    :group => MENU_GROUP[:operation],
    :position => 3
  } ,
  :sales_menu => {
    :nodes => [
                  
          [ "api/sales_orders", false, "Penjualan"  ], 
          [ "api/delivery_orders", false, "Pengiriman" ] ,
          [ "api/sales_invoices", false, "Sales Invoice" ]  

        ] ,
    :text => "Sales" ,
    :group => MENU_GROUP[:operation],
    :position => 4
  } ,
  :purchase_menu => {
    :nodes => [
                  
          [ "api/purchase_orders", false , "Purchase Order" ], 
          [ "api/purchase_receivals", false , "Penerimaan"] ,
          [ "api/purchase_invoices", false, "Purchase Invoice" ]  

        ] ,
    :text => "Purchase" ,
    :group => MENU_GROUP[:operation],
    :position => 5
  } ,
  :finance_ops_menu => {
    :nodes => [
                  
          [ "api/payment_requests", false, "Payment Request"  ], 
          [ "api/payment_vouchers", false, "Payment Voucher" ] ,
          [ "api/receipt_vouchers", false, "Receipt Voucher" ] , 

        ] ,
    :text => "Finance Ops" ,
    :group => MENU_GROUP[:operation],
    :position => 6
  } ,
  :accounting_ops_menu => {
    :nodes => [
         
          [ "api/memorials", false , "Memorial" ], 
          [ "api/closings", false, "Closing" ]   

        ] ,
    :text => "Accounting Ops" ,
    :group => MENU_GROUP[:operation],
    :position => 7
  } ,
  :cash_bank_ops_menu => {
    :nodes => [
                  
         
          [ "api/cash_bank_adjustments", false , "CashBank Adjustment" ], 
          [ "api/cash_bank_mutations", false , "CashBank Mutation" ]   
  
        ] ,
    :text => "CashBank Ops" ,
    :group => MENU_GROUP[:operation],
    :position => 7
  } ,
  
  
}


 

  





 
 
# api/blanket_order_details
# api/blanket_orders
# api/blanket_work_processs 
# api/blending_work_orders   
  
 

# api/payables     
# api/receivables
# api/recovery_order_details
# api/recovery_orders
# api/recovery_work_process_details
# api/recovery_work_processs 
# api/roller_acc_details
# api/roller_accs 
# api/roller_identification_form_details
# api/roller_identification_forms
   


# api/temporary_delivery_order_details
# api/temporary_delivery_orders

# api/virtual_delivery_order_details
# api/virtual_delivery_orders
# api/virtual_order_clearance_details
# api/virtual_order_clearances
# api/virtual_order_details
# api/virtual_orders
 