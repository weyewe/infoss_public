role = {
  'system' => {
    'administrator' => true
  }
}

admin_role = Role.create!(
  :name        => ROLE_NAME[:admin],
  :title       => 'Administrator',
  :description => 'Role for administrator',
  :the_role    => role.to_json
)

# admin_role = TheRole.create_admin!

# update admin_role
# https://github.com/TheRole/docs/blob/master/MigrationsFromV2.md
# change role.rb 
#  admin_role.create_rule(:system, :administrator)
      # admin_role.rule_on(:system, :administrator)
# 

role = {
  :passwords => {
    :update => true 
  },
  :works => {
    :index => true, 
    :create => true,
    :update => true,
    :destroy => true,
    :work_reports => true ,
    :project_reports => true ,
    :category_reports => true 
  },
  :projects => {
    :search => true 
  },
  :categories => {
    :search => true 
  }
}

data_entry_role = Role.create!(
  :name        => ROLE_NAME[:data_entry],
  :title       => 'Data Entry',
  :description => 'Role for data_entry',
  :the_role    => role.to_json
)



#if Rails.env.development?

  admin = User.create_main_user(  :name => "Admin", :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user


  admin = User.create_main_user(  :name => "Admin2", :email => "admin2@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user
  
  admin = User.create_main_user(  :name => "Admin4", :email => "admin4@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 
  admin.set_as_main_user
  
data_entry = User.create_object(
  :name => "jojo",
  :email => "jojo@gmail.com",
  :password => "jojo1234",
  :password_confirmation => "jojo1234",
  :role_id => data_entry_role.id
  )
  
  
  Account.create_base_objects
  Exchange.create_object_for_base_exchange
  ItemType.create_base_objects
  Section.create_base_section_actions

if Rails.env.development?

# if Rails.env.production?
# if Rails.env.test?
  # creating contact group  
  contact_group_array = [] 
  
  (1.upto 5).each do |x|
    contact_group_array << ContactGroup.create_object(
        :name => "contact group name #{x}",
        :description => "description of the contact group #{x}"
      )
  end
  
  # creating supplier 
  
  # puts "contact_group_array: #{contact_group_array}"
  
  supplier_array = [] 
  (1.upto 5).each do |x|
    supplier_array << Contact.create_object(
    :name => "Supplier #{x}",
        :address =>"öffice address of #{x}",
        :contact_no => "tjeconcatnno_ #{x} supplier",
        :delivery_address =>" delivery address of #{x}",
        :description => "description of the contact group #{x}",
        :default_payment_term =>  x , 
        :npwp => "234234#{x}", 
        :is_taxable => true,  
        :tax_code => "23222afwea#{x}",
        :nama_faktur_pajak => "awesome supplier #{x}",
        :pic => "awesome supplier pic #{x}",
        :pic_contact_no => "2342#{x}",
        :email => "supplier_#{x}@gmail.com",
        :contact_type => CONTACT_TYPE[:supplier],
        :contact_group_id => contact_group_array[ rand(0..( contact_group_array.length - 1 ) )].id
      )
  end
  
  customer_array = [] 
  (1.upto 5).each do |x|
    customer_array << Contact.create_object(
        :name => "Customer #{x}",
        :address =>"öffice address of customer #{x}",
        :contact_no => "tjeconcatnno_ #{x} customer",
        :delivery_address =>" delivery address of #{x}",
        :description => "description of the customer group #{x}",
        :default_payment_term =>  x , 
        :npwp => "2cust34234#{x}", 
        :is_taxable => true,  
        :tax_code => TAX_CODE[:code_01],
        :nama_faktur_pajak => "awesome customer #{x}",
        :pic => "awesome customer pic #{x}",
        :pic_contact_no => "2342#{x}",
        :email => "customer_#{x}@gmail.com",
        :contact_type => CONTACT_TYPE[:customer],
        :contact_group_id => contact_group_array[ rand(0..( contact_group_array.length - 1 ) )].id
      )
  end
  
  employee_array = []
  (1.upto 5).each do |x|
    employee_array << Employee.create_object(
        :name => "Employee #{x}",
        :contact_no => "tjeconcatnno_ #{x} employee",
        :address => "address of #{x}",
        :description => "description of the customer group #{x}",
        :email => "customer_#{x}@gmail.com",
      )
  end
  
  # creating account_array
  ledger_account_array = [] 
  Account.active_accounts.where(:account_case => ACCOUNT_CASE[:ledger] ).each do |account|
    ledger_account_array << account 
  end
  
  
  item_type_array = [] 
  ItemType.create_base_objects
  (1.upto 10).each do |x|
    
    item_type_array << ItemType.create_object(
        :name => "Item Type name #{x}",
        :sku => "Sku #{x}",
        :description => "Item type description #{x}",
        :account_id => ledger_account_array[  rand( 0..(ledger_account_array.length - 1 ))].id 
        
      )
  end
  
  sub_type_array = [] 
  (1.upto 10).each do |x|
    
    sub_type_array << SubType.create_object(
        :name => "Sub Type name #{x}", 
        :item_type_id => item_type_array[  rand( 0..(item_type_array.length - 1 ))].id 
        
      )
  end
  
  uom_array = []
  (1.upto 10).each do |x|
    
     uom_array << Uom.create_object(
        :name => "unit of measurement #{x}",   
        
      )
  end
  
  warehouse_array = []
  (1.upto 10).each do |x|
    
    warehouse_array << Warehouse.create_object(
        :name => "wh name #{x}",   
        :code => "wh code #{x}",   
        :description => "wh description #{x}",   
        
      )
  end
  
  machine_array = []
  (1.upto 10).each do |x|
    
    machine_array << Machine.create_object(
        :name => "machine name #{x}",   
        :code => "machine code #{x}",   
        :description => "machine description #{x}",   
        
      )
  end
  
  roller_type_array = []
  (1.upto 10).each do |x|
    
    roller_type_array << RollerType.create_object(
        :name => "roller type  name #{x}",   
        :description => "roller type description #{x}",   
        
      )
  end
  
  exchange_array = []
  (1.upto 10).each do |x|
    
     exchange_array << Exchange.create_object(
        :name => "exchanges name #{x}",   
        :description => "exchanges description #{x}",   
        
      )
  end 
  
  cashbank_array = [] 
  (1.upto 10).each do |x|
    selected_exchange = exchange_array[  rand( 0..(exchange_array.length - 1 ))]
     cashbank_array << CashBank.create_object(
        :name => "cb #{x}",   
        :exchange_id => selected_exchange.id, 
        :description => "exchanges description #{x}",   
        :code => "code #{x}"
      )
  end 
  
  
  multiplier = [2,3,5,6,4,3,4]
  exchange_array.each do |ea|
      selected_multiplier = multiplier[  rand( 0..(multiplier.length - 1 ))]
      ExchangeRate.create_object(
              :exchange_id => ea.id , 
              :rate => BigDecimal("1") * selected_multiplier,
              :ex_rate_date => DateTime.now 
          )
  end
  
  

  
  item_array = [] 
  (1.upto 10).each do |x|
    selected_uom = uom_array[  rand( 0..(uom_array.length - 1 ))]
    # selected_sub_type =  nil 
    # selected_item_type = selected_sub_type.item_type 
    selected_item_type = ItemType.where(:is_batched => true).first 
    selected_exchange = exchange_array[  rand( 0..(exchange_array.length - 1 ))]
    
    item_array << Item.create_object(
        :sub_type_id => nil, 
        :item_type_id => selected_item_type.id , 
        :exchange_id => selected_exchange.id , 
        :uom_id => selected_uom.id ,
        
        :name => "item_name #{x}",
        :sku => "sjhfwjeklf#{x}",
        :minimum_amount => BigDecimal( x.to_s ),
        
        :is_tradeable => true , 
        :selling_price => BigDecimal("1000") * x ,
        :price_list => BigDecimal("20000") * x ,
        :description => "The description #{x}"
        
      )
  end
  
  item_roll_blanket_array = [] 
  (1.upto 10).each do |x|
    selected_uom = uom_array[  rand( 0..(uom_array.length - 1 ))]
    # selected_sub_type =  nil 
    # selected_item_type = selected_sub_type.item_type 
    selected_exchange = exchange_array[  rand( 0..(exchange_array.length - 1 ))]
    
    item_roll_blanket_array << Item.create_object(
        :sub_type_id => nil, 
        :item_type_id => ItemType.where(:name => BASE_ITEM_TYPE[:roll_blanket]).first.id  , 
        :exchange_id => selected_exchange.id , 
        :uom_id => selected_uom.id ,
        
        :name => "rb #{x}",
        :sku => "rb#{x}",
        :minimum_amount => BigDecimal( x.to_s ),
        
        :is_tradeable => true , 
        :selling_price => BigDecimal("1000") * x ,
        :price_list => BigDecimal("20000") * x ,
        :description => "The description #{x}"
        
      )
  end
  
  item_adhesive_blanket_array = [] 
  (1.upto 10).each do |x|
    selected_uom = uom_array[  rand( 0..(uom_array.length - 1 ))]
    # selected_sub_type =  nil 
    # selected_item_type = selected_sub_type.item_type 
    selected_exchange = exchange_array[  rand( 0..(exchange_array.length - 1 ))]
    
    item_adhesive_blanket_array << Item.create_object(
        :sub_type_id => nil, 
        :item_type_id => ItemType.where(:name => BASE_ITEM_TYPE[:adhesive_blanket]).first.id, 
        :exchange_id => selected_exchange.id , 
        :uom_id => selected_uom.id ,
        
        :name => "ab name #{x}",
        :sku => "ab#{x}",
        :minimum_amount => BigDecimal( x.to_s ),
        
        :is_tradeable => true , 
        :selling_price => BigDecimal("1000") * x ,
        :price_list => BigDecimal("20000") * x ,
        :description => "The description #{x}"
        
      )
  end
  
  
  item_adhesive_roller_array = [] 
  (1.upto 10).each do |x|
    selected_uom = uom_array[  rand( 0..(uom_array.length - 1 ))]
    # selected_sub_type =  nil 
    # selected_item_type = selected_sub_type.item_type 
    selected_exchange = exchange_array[  rand( 0..(exchange_array.length - 1 ))]
    
    item_adhesive_roller_array << Item.create_object(
        :sub_type_id => nil, 
        :item_type_id => ItemType.where(:name => BASE_ITEM_TYPE[:adhesive_roller]).first.id , 
        :exchange_id => selected_exchange.id , 
        :uom_id => selected_uom.id ,
        
        :name => "ad name #{x}",
        :sku => "ar#{x}",
        :minimum_amount => BigDecimal( x.to_s ),
        
        :is_tradeable => true , 
        :selling_price => BigDecimal("1000") * x ,
        :price_list => BigDecimal("20000") * x ,
        :description => "The description #{x}"
        
      )
  end
  
  
  item_bar_array = [] 
  (1.upto 10).each do |x|
    selected_uom = uom_array[  rand( 0..(uom_array.length - 1 ))]
    # selected_sub_type =  nil 
    # selected_item_type = selected_sub_type.item_type 
    selected_exchange = exchange_array[  rand( 0..(exchange_array.length - 1 ))]
    
    item_bar_array << Item.create_object(
        :sub_type_id => nil, 
        :item_type_id => ItemType.where(:name => BASE_ITEM_TYPE[:bar]).first.id , 
        :exchange_id => selected_exchange.id , 
        :uom_id => selected_uom.id ,
        
        :name => "bar name #{x}",
        :sku => "bar#{x}",
        :minimum_amount => BigDecimal( x.to_s ),
        
        :is_tradeable => true , 
        :selling_price => BigDecimal("1000") * x ,
        :price_list => BigDecimal("20000") * x ,
        :description => "The description #{x}"
        
      )
  end
  
  item_compound_array = [] 
  (1.upto 10).each do |x|
    selected_uom = uom_array[  rand( 0..(uom_array.length - 1 ))]
    # selected_sub_type =  nil 
    # selected_item_type = selected_sub_type.item_type 
    selected_exchange = exchange_array[  rand( 0..(exchange_array.length - 1 ))]
    
    item_compound_array << Item.create_object(
        :sub_type_id => nil, 
        :item_type_id => ItemType.where(:name => BASE_ITEM_TYPE[:compound]).first.id , 
        :exchange_id => selected_exchange.id , 
        :uom_id => selected_uom.id ,
        
        :name => "compound name #{x}",
        :sku => "com#{x}",
        :minimum_amount => BigDecimal( x.to_s ),
        
        :is_tradeable => true , 
        :selling_price => BigDecimal("1000") * x ,
        :price_list => BigDecimal("20000") * x ,
        :description => "The description #{x}"
        
      )
  end
  
  
  ItemType.all.each do |item_type| 
    next if item_type.items.count == 0 
    item = item_type.items.first 
    (1.upto 10).each do  |counter | 
      BatchInstance.create_object(
        :item_id         =>  item.id , 
        :name            =>  "#{item_type.name} #{counter}",
        :description     =>  "The description",
        :manufactured_at => DateTime.now  
      )
    end
  end
  
  stock_adjustment_array =[]
  # (1.upto 10).each do |x|
  Warehouse.all.each do |selected_warehouse| 
    stock_adjustment = StockAdjustment.create_object(
      :warehouse_id => selected_warehouse.id , 
      :adjustment_date => DateTime.now 
      )
    Item.all.each do |selected_item| 
      StockAdjustmentDetail.create_object(
        :stock_adjustment_id => stock_adjustment.id,
        :item_id => selected_item.id,
        :price => BigDecimal("1000"),
        :amount => 1000,
        :status => ADJUSTMENT_STATUS[:addition],
        )
    end
 
      stock_adjustment.confirm_object(:confirmed_at => DateTime.now )
      puts "Fark stock adjustment is not confirmed " if not stock_adjustment.is_confirmed?
      stock_adjustment.errors.messages.each {|x| puts "error in stock adjustment: #{x}" }
      stock_adjustment_array << stock_adjustment
 
  end
  
  # warehouse_mutation_array = []
  # (1.upto 10).each do |x|
  #   selected_warehouse_from = warehouse_array[rand( 0..(warehouse_array.length - 6 ))]
  #   selected_warehouse_to = warehouse_array[rand( 6..(warehouse_array.length - 1 ))]
  #   warehouse_mutation = WarehouseMutation.create_object(
  #     :warehouse_from_id => selected_warehouse_from.id,
  #     :warehouse_to_id => selected_warehouse_to.id,
  #     :mutation_date => DateTime.now
  #     )
  #   (1.upto 10).each do |y| 
  #     selected_item = item_array[rand( 0..(item_array.length - 1 ))]
  #     WarehouseMutationDetail.create_object(
  #       :warehouse_mutation_id => warehouse_mutation.id,
  #       :item_id => selected_item.id,
  #       :amount => 1
  #       )
  #   end
  #   if not warehouse_mutation.errors.size == 0
  #     warehouse_mutation.confirm_object(:confirmed_at =>DateTime.now)
  #     puts "farkk. warehouse mutation is not confirmed" if not warehouse_mutation.is_confirmed? 
  #     warehouse_mutation_array << warehouse_mutation
  #   end
  # end
  
  cashbank_adjustment_array = []
  (1.upto 10).each do |x|
    selected_cashbank = cashbank_array[rand( 0..(cashbank_array.length - 1))]
    cashbank_adjustment = CashBankAdjustment.create_object(
      :cash_bank_id => selected_cashbank.id,
      :amount => BigDecimal("1000000"),
      :status => ADJUSTMENT_STATUS[:addition],
      :adjustment_date => DateTime.now,
      :description => "The description  #{x}"
      )
    if cashbank_adjustment.errors.size == 0 
      cashbank_adjustment.confirm_object(:confirmed_at => DateTime.now)
    end
    cashbank_adjustment_array << cashbank_adjustment
  end
  
  cash_bank_mutation_array = []
  (1.upto 10).each do |x|
    selected_target_cashbank = cashbank_array[rand( 0..(cashbank_array.length - 6))]
    selected_source_cashbank = cashbank_array[rand( 6..(cashbank_array.length - 1))]
    cash_bank_mutation = CashBankMutation.create_object(
      :target_cash_bank_id => selected_target_cashbank.id,
      :source_cash_bank_id => selected_source_cashbank.id,
      :amount => BigDecimal("1000"),
      :description => "The Description #{x}",
      :mutation_date => DateTime.now
      )
    if cash_bank_mutation.errors.size == 0 
      cash_bank_mutation.confirm_object(:confirmed_at => DateTime.now)
    end
    cash_bank_mutation_array << cash_bank_mutation
  end
  
  payment_request_array = []
  (1.upto 10).each do |x|
    selected_contact = supplier_array[rand( 0..(supplier_array.length - 1))]
    selected_exchange = exchange_array[rand( 0..(supplier_array.length - 1))]
    selected_ledger_account = ledger_account_array[rand( 0..(ledger_account_array.length - 1))]
    payment_request = PaymentRequest.create_object(
      :contact_id => selected_contact.id,
      :request_date => DateTime.now,
      :due_date => DateTime.now,
      :exchange_id => selected_exchange.id,
      :account_id => selected_ledger_account.id,
      )
    (1.upto 5).each do |y|
    selected_ledger_account_detail = ledger_account_array[rand( 0..(ledger_account_array.length - 1))]
    PaymentRequestDetail.create_object(
      :payment_request_id => payment_request.id,
      :account_id => selected_ledger_account_detail.id,
      :status => NORMAL_BALANCE[:debit],
      :amount => BigDecimal("1000"),
      )
    end
    payment_request.reload
    payment_request.confirm_object(payment_request)
    payment_request_array << payment_request
  end
  
  purchase_order_array = []
  (1.upto 10).each do |x|
    selected_exchange = exchange_array[rand(0..(exchange_array.length - 1))]
    selected_contact = supplier_array[rand(0..(supplier_array.length - 1))]
    purchase_order = PurchaseOrder.create_object(
      :contact_id => selected_contact.id,
      :purchase_date => DateTime.now,
      :exchange_id => selected_exchange.id,
      :description => "The description #{x}",
      :nomor_surat => "nomor_surat #{x}",
      :allow_edit_detail => false
      )
    (1.upto 10).each do |y|
      selected_item = item_array[rand(0..(item_array.length - 1))]
      PurchaseOrderDetail.create_object(
        :purchase_order_id => purchase_order.id,
        :item_id => selected_item.id,
        :amount => BigDecimal("1"),
        :price => BigDecimal("1000"),
        )
    end
    if purchase_order.errors.size == 0 
      purchase_order.reload
      purchase_order.confirm_object(:confirmed_at => DateTime.now)
    end
    purchase_order_array << purchase_order
  end
  
  purchase_receival_array = []
  (1.upto 10).each do |x|
    selected_purchase_order = purchase_order_array[rand(0..(purchase_order_array.length - 1))]
    selected_warehouse = warehouse_array[rand(0..(purchase_order_array.length - 1))]
    purchase_receival = PurchaseReceival.create_object(
      :purchase_order_id => selected_purchase_order.id,
      :warehouse_id => selected_warehouse.id,
      :receival_date => DateTime.now,
      :nomor_surat => "nomor_surat #{x}",
      )
    (1.upto 3).each do |y|
      selected_purchase_order_detail =
      selected_purchase_order.purchase_order_details[rand(0..
      (selected_purchase_order.purchase_order_details.length - 1))]
      PurchaseReceivalDetail.create_object(
        :purchase_receival_id => purchase_receival.id,
        :purchase_order_detail_id => selected_purchase_order_detail.id,
        :amount => BigDecimal("1"),
        )
    end
    if purchase_receival.errors.size == 0
      purchase_receival.reload
      purchase_receival.confirm_object(:confirmed_at => DateTime.now)
      purchase_receival_array << purchase_receival 
    end
  end
  
  purchase_invoice_array = []
  (1.upto 10).each do |x|
    selected_purchase_receival = purchase_receival_array[rand(0..(purchase_receival_array.length - 1))]
    purchase_invoice = PurchaseInvoice.create_object(
      :purchase_receival_id => selected_purchase_receival.id,
      :invoice_date => DateTime.now,
      :nomor_surat => "nomor_surat #{x}",
      :description => "the description #{x}",
      :due_date => DateTime.now
      )
    (1.upto 4).each do |y|
      selected_purchase_receival_detail = 
      selected_purchase_receival.purchase_receival_details[rand(0..
      (selected_purchase_receival.purchase_receival_details.length - 1))]
      PurchaseInvoiceDetail.create_object(
        :purchase_invoice_id => purchase_invoice.id,
        :purchase_receival_detail_id => selected_purchase_receival_detail.id,
        :amount => BigDecimal("1")
        )
    end
    if purchase_invoice.errors.size == 0 
      purchase_invoice.confirm_object(:confirmed_at => DateTime.now)
      purchase_invoice_array << purchase_invoice
    end
    
  end
  
  payable_array = []
  Payable.all.each do |payable|
    payable_array << payable 
  end
  
  payment_voucher_array = []
  (1.upto 10).each do |x|
    selected_cashbank = cashbank_array[rand(0..(cashbank_array.length - 1))]
    selected_contact = supplier_array[rand(0..(supplier_array.length - 1))]
    payment_voucher = PaymentVoucher.create_object(
      :no_bukti => "no_bukti #{x}",
      :is_gbch => false,
      :due_date => DateTime.now,
      :pembulatan => BigDecimal("0"),
      :biaya_bank => BigDecimal("0"),
      :rate_to_idr => BigDecimal("1"),
      :payment_date => DateTime.now,
      :contact_id => selected_contact.id,
      :cash_bank_id => selected_cashbank.id,
      )
    (1.upto 4).each do |y|
      selected_payable = payable_array[rand(0..(payable_array.length - 1))]
      PaymentVoucherDetail.create_object(
        :payment_voucher_id => payment_voucher.id,
        :payable_id => selected_payable.id,
        :amount_paid => BigDecimal("100"),
        :pph_21 => BigDecimal("0"),
        :pph_23 => BigDecimal("0"),
        :rate => BigDecimal("1")
        )
    end
    if payment_voucher.errors.size == 0 
      payment_voucher.confirm_object(:confirmed_at => DateTime.now)
    end
  end
  
  sales_order_array = []
  (1.upto 10).each do |x|
    selected_employee = employee_array[rand(0..(employee_array.length - 1))]
    selected_contact = customer_array[rand(0..(customer_array.length - 1))]
    selected_exchange = exchange_array[rand(0..(exchange_array.length - 1))]
    sales_order = SalesOrder.create_object(
      :contact_id => selected_contact.id,
      :employee_id => selected_employee.id,
      :sales_date => DateTime.now,
      :nomor_surat => "Nomor surat #{x}",
      :exchange_id => selected_exchange.id
      )
    (1.upto 4).each do |y|
      selected_item = item_array[rand(0..(item_array.length - 1))]
      SalesOrderDetail.create_object(
        :sales_order_id => sales_order.id,
        :item_id => selected_item.id,
        :is_service => false,
        :amount => BigDecimal("2"),
        :price => BigDecimal("1000")
        )
    end
    if sales_order.errors.size == 0 
      sales_order.reload
      sales_order.confirm_object(:confirmed_at => DateTime.now)
      puts "Fark sales order is not confirmed " if not sales_order.is_confirmed?
      sales_order_array << sales_order
    end
  end
  
  delivery_order_array = []
  counter  = 0 
  (1.upto 2).each do |x|
    counter = counter + 1 
    selected_warehouse = warehouse_array[rand(0..(warehouse_array.length - 1))]
    selected_sales_order = sales_order_array[rand(0..(sales_order_array.length - 6))]
    delivery_order = DeliveryOrder.create_object(
      :warehouse_id => selected_warehouse.id,
      :delivery_date => DateTime.now,
      :nomor_surat => "Nomor surat #{x}",
      :sales_order_id => selected_sales_order.id
      )
    # (1.upto 4).each do |y| 
    detail_counter = 0
    selected_sales_order.sales_order_details.each do |selected_sales_order_detail|
      detail_counter = detail_counter + 1 
      selected_item = item_array[rand(0..(item_array.length - 1))]
      # selected_sales_order_detail = 
      # selected_sales_order.sales_order_details[rand(0..(selected_sales_order.sales_order_details.length - 1))]
      DeliveryOrderDetail.create_object(
        :delivery_order_id => delivery_order.id,
        :sales_order_detail_id => selected_sales_order_detail.id,
        :order_code => "Order #{selected_sales_order_detail.id}",
        :amount => BigDecimal("2"),
        )
    end
    if delivery_order.errors.size == 0 
      delivery_order.reload
      delivery_order.confirm_object(:confirmed_at => DateTime.now)
      delivery_order.errors.messages.each {|x| puts "the delivery order confirm error: #{x}" }
      if not delivery_order.is_confirmed?
        puts "Fark delivery order is not confirmed "
        delivery_order.delivery_order_details.each do |x|
          puts "item requested: #{x.item.sku}, ready quantity : #{x.item.amount}. Requested quantity :#{x.amount}"
        end
      end
      delivery_order_array << delivery_order
    end
  end
  
  delivery_order_non_detail_array = []
  (1.upto 5).each do |x|
    selected_warehouse = warehouse_array[rand(0..(warehouse_array.length - 1))]
    selected_sales_order = sales_order_array[rand(6..(sales_order_array.length - 1))]
    delivery_order = DeliveryOrder.create_object(
      :warehouse_id => selected_warehouse.id,
      :delivery_date => DateTime.now,
      :nomor_surat => "Nomor surat #{x}",
      :sales_order_id => selected_sales_order.id
      )
      delivery_order.confirm_object(:confirmed_at => DateTime.now)
      delivery_order_non_detail_array << delivery_order
  end
  
  temporary_delivery_order_array = []
  (1.upto 5).each do |x|
    selected_warehouse = warehouse_array[rand(0..(warehouse_array.length - 1))]
    selected_delivery_order = delivery_order_non_detail_array[rand(0..(delivery_order_non_detail_array.length - 1))]
    temporary_delivery_order = TemporaryDeliveryOrder.create_object(
      :warehouse_id => selected_warehouse.id,
      :delivery_date => DateTime.now,
      :nomor_surat => "Nomor surat #{x}",
      :delivery_order_id => selected_delivery_order.id
      )
    (1.upto 4).each do |y|
      selected_sales_order_detail = 
      selected_delivery_order.sales_order.sales_order_details[rand(0..(selected_delivery_order.sales_order.sales_order_details.length - 1))]
      TemporaryDeliveryOrderDetail.create_object(
        :temporary_delivery_order_id => temporary_delivery_order.id,
        :sales_order_detail_id => selected_sales_order_detail.id,
        :amount => BigDecimal("2"),
        )
    end
    if temporary_delivery_order.errors.size == 0 
      temporary_delivery_order.reload
      temporary_delivery_order.confirm_object(:confirmed_at => DateTime.now)
      temporary_delivery_order_array << temporary_delivery_order
    end
  end
  
   
  virtual_order_array = []
  (1.upto 10).each do |x|
    selected_contact = customer_array[rand(0..(customer_array.length - 1))]
    selected_employee = employee_array[rand(0..(employee_array.length - 1))]
    selected_exchange = exchange_array[rand(0..(exchange_array.length - 1))]
    virtual_order = VirtualOrder.create_object(
      :contact_id => selected_contact.id,
      :employee_id => selected_employee.id,
      :exchange_id => selected_exchange.id,
      :order_date => DateTime.now,
      :order_type => ORDER_TYPE_CASE[:trial_order],
      :nomor_surat => "Nomor surat #{x}"
      )
    (1.upto 4).each do |y|
      selected_item = item_array[rand(0..(item_array.length - 1))]
      VirtualOrderDetail.create_object(
        :virtual_order_id => virtual_order.id,
        :item_id => selected_item.id,
        :amount => BigDecimal("10"),
        :price => BigDecimal("1000")
        )
    end
    if virtual_order.errors.size == 0 
      virtual_order.reload
      virtual_order.confirm_object(:confirmed_at => DateTime.now)
      virtual_order_array << virtual_order
    end
  end
  
  virtual_delivery_order_array = []
  (1.upto 10).each do |x|
    selected_virtual_order = virtual_order_array[rand(0..(virtual_order_array.length - 1))]
    selected_warehouse = warehouse_array[rand(0..(warehouse_array.length - 1))]
    virtual_delivery_order = VirtualDeliveryOrder.create_object(
      :virtual_order_id => selected_virtual_order.id,
      :warehouse_id => selected_warehouse.id,
      :delivery_date => DateTime.now,
      :nomor_surat => "Nomor surat #{x}",
      :order_type => ORDER_TYPE_CASE[:trial_order]
      )
    (1.upto 4).each do |y|
      selected_virtual_order_detail = 
      selected_virtual_order.virtual_order_details[rand(0..(selected_virtual_order.virtual_order_details.length - 1))]
      vd = VirtualDeliveryOrderDetail.create_object(
        :virtual_delivery_order_id => virtual_delivery_order.id,
        :virtual_order_detail_id => selected_virtual_order_detail.id,
        :amount => BigDecimal("2")
        )
    end
    if virtual_delivery_order.errors.size == 0 
      virtual_delivery_order.reload
      virtual_delivery_order.confirm_object(:confirmed_at => DateTime.now)
      virtual_delivery_order_array << virtual_delivery_order
    end
  end
  
  virtual_order_clearance_array = []
  (1.upto 10).each do |x|
    selected_virtual_delivery_order = virtual_delivery_order_array[rand(0..(virtual_delivery_order_array.length - 1))]
    virtual_order_clearance = VirtualOrderClearance.create_object(
      :virtual_delivery_order_id => selected_virtual_delivery_order.id,
      :clearance_date => DateTime.now,
      )
    (1.upto 4).each do |y|
      selected_virtual_delivery_order_detail = 
      selected_virtual_delivery_order.virtual_delivery_order_details[rand(0..(selected_virtual_delivery_order.virtual_delivery_order_details.length - 1))]
      VirtualOrderClearanceDetail.create_object(
        :virtual_order_clearance_id => virtual_order_clearance.id,
        :virtual_delivery_order_detail_id => selected_virtual_delivery_order_detail.id,
        :amount => BigDecimal("2")
        )
    end
    if virtual_order_clearance.errors.size == 0 
      virtual_order_clearance.reload
      virtual_order_clearance.confirm_object(:confirmed_at => DateTime.now)
      virtual_order_clearance_array << virtual_order_clearance
    end
  end
  
  # puts "virtual_order_clearance_array: #{virtual_order_clearance_array}"
  
  sales_invoice_array = []
  (1.upto 10).each do |x|
    selected_delivery_order = delivery_order_array[rand(0..(delivery_order_array.length - 1))]
    sales_invoice = SalesInvoice.create_object(
      :description => "the description #{x}",
      :due_date => DateTime.now,
      :invoice_date => DateTime.now,
      :nomor_surat => "Nomor surat #{x}",
      :delivery_order_id => selected_delivery_order.id
      )
    (1.upto 4).each do |y|
      selected_delivery_order_detail = 
      selected_delivery_order.delivery_order_details[rand(0..(selected_delivery_order.delivery_order_details.length - 1))]
      SalesInvoiceDetail.create_object(
        :sales_invoice_id => sales_invoice.id,
        :delivery_order_detail_id => selected_delivery_order_detail.id,
        :amount => BigDecimal("2"),
        )
    end
    if sales_invoice.errors.size == 0 
      sales_invoice.reload
      sales_invoice.confirm_object(:confirmed_at => DateTime.now)
      sales_invoice_array << sales_invoice
    end
  end
  
  receivable_array = []
  Receivable.all.each do |receivable|
    receivable_array << receivable 
  end
  receipt_voucher_array = []
  (1.upto 10).each do |x|
    selected_cashbank = cashbank_array[rand(0..(cashbank_array.length - 1))]
    selected_contact = supplier_array[rand(0..(supplier_array.length - 1))]
    receipt_voucher = ReceiptVoucher.create_object(
      :no_bukti => "no_bukti #{x}",
      :is_gbch => false,
      :due_date => DateTime.now,
      :pembulatan => BigDecimal("0"),
      :biaya_bank => BigDecimal("0"),
      :rate_to_idr => BigDecimal("10"),
      :receipt_date => DateTime.now,
      :contact_id => selected_contact.id,
      :cash_bank_id => selected_cashbank.id,
      )
    (1.upto 4).each do |y|
      selected_receivable = receivable_array[rand(0..(receivable_array.length - 1))]
      ReceiptVoucherDetail.create_object(
        :receipt_voucher_id => receipt_voucher.id,
        :receivable_id => selected_receivable.id,
        :amount_paid => BigDecimal("100"),
        :pph_23 => BigDecimal("0"),
        :rate => BigDecimal("10")
        )
    end
    if receipt_voucher.errors.size == 0 
      receipt_voucher.reload
      receipt_voucher.confirm_object(:confirmed_at => DateTime.now)
      receipt_voucher_array << receipt_voucher
    end
  end
  
  core_builder_array = []
  (1.upto 10).each do |x|
    selected_machine = machine_array[rand(0..(machine_array.length - 1))]
    selected_uom = uom_array[rand(0..(uom_array.length - 1))]
    core_builder_array << CoreBuilder.create_object(
        :base_sku => "corebuilder#{x}",
        :name => "corebuildername #{x}",
        :description => "desc #{x}",
        :uom_id => selected_uom.id,
        :machine_id => selected_machine.id,
        :core_builder_type_case => CORE_BUILDER_TYPE[:shaft],
        :cd => 10,
        :tl => 10   
      )
  end
  
  roller_builder_array = []
  (1.upto 10).each do |x|
    selected_core_builder = core_builder_array[rand(0..(core_builder_array.length - 1))]
    selected_uom = uom_array[rand(0..(uom_array.length - 1))]
    selected_machine = machine_array[rand(0..(machine_array.length - 1))]
    selected_roller_type = roller_type_array[rand(0..(roller_type_array.length - 1))]
    selected_adhesive_roller = item_adhesive_roller_array[rand(0..(item_adhesive_roller_array.length - 1))]
    selected_compound = item_compound_array[rand(0..(item_compound_array.length - 1))]
    selected_compound = item_compound_array[rand(0..(item_compound_array.length - 1))]
    roller_builder_array << RollerBuilder.create_object(
        :base_sku => "rollerbuilder#{x}",
        :name => "rollerbuildername#{x}",
        :description => "desc #{x}",
        :uom_id => selected_uom.id,
        :adhesive_id => selected_adhesive_roller.id,
        :compound_id => selected_compound.id,
        :machine_id =>selected_machine.id,
        :roller_type_id => selected_roller_type.id,
        :core_builder_id => selected_core_builder.id,
        :is_grooving => true,
        :is_crowning => true,
        :is_chamfer => true,
        :crowning_size => 1,
        :grooving_width => 2,
        :grooving_depth => 3,
        :grooving_position => 4,
        :cd => 5,
        :rd => 6,
        :rl => 7,
        :wl => 8,
        :tl => 9,
      )
  end
  
  blanket_array = []
  (1.upto 10).each do |x|
    selected_core_builder = core_builder_array[rand(0..(core_builder_array.length - 1))]
    selected_uom = uom_array[rand(0..(uom_array.length - 1))]
    selected_machine = machine_array[rand(0..(machine_array.length - 1))]
    selected_contact = customer_array[rand(0..(customer_array.length - 1))]
    selected_roller_type = roller_type_array[rand(0..(roller_type_array.length - 1))]
    selected_roll_blanket = item_roll_blanket_array[rand(0..(item_roll_blanket_array.length - 1))]
    selected_adhesive_blanket = item_adhesive_blanket_array[rand(0..(item_adhesive_roller_array.length - 1))]
    selected_compound = item_compound_array[rand(0..(item_compound_array.length - 1))]
    selected_bar = item_bar_array[rand(0..(item_bar_array.length - 1))]
    selected_exchange = exchange_array[rand(0..(exchange_array.length - 1))]
    blanket_array << Blanket.create_object(
        :sku => "blanket#{x}",
        :name => "blanketname#{x}",
        :description => "desc#{x}",
        :uom_id => selected_uom.id,
        :roll_no => "roll#{x}",
        :contact_id => selected_contact.id,
        :machine_id => selected_machine.id,
        :adhesive_id => selected_adhesive_blanket.id,
        :adhesive2_id => selected_adhesive_blanket.id,
        :roll_blanket_item_id => selected_roll_blanket.id,
        :left_bar_item_id => selected_bar.id,
        :right_bar_item_id => selected_bar.id,
        :ac => 1,
        :ar => 2,
        :thickness =>3,
        :is_bar_required => true,
        :cropping_type => CROPPING_TYPE[:normal],
        :special => 4,
        :application_case => APPLICATION_CASE[:sheetfed],
        :left_over_ac => 5,
        :left_over_ar => 6,
        :minimum_amount => BigDecimal("1"),
        :selling_price => BigDecimal("2000"),
        :price_list => BigDecimal("500"),
        :exchange_id => selected_exchange.id,
      )
  end
  
  blending_recipe_array = []
  (1.upto 10).each do |x|
    selected_item = item_array[rand(0..(item_array.length - 4))]
    selected_contact = supplier_array[rand(0..(supplier_array.length - 1))]
    blending_recipe = BlendingRecipe.create_object(
        :name => "blendingrecipe name#{x}",
        :description => "desc#{x}",
        :target_item_id => selected_item.id,
        :target_amount => 1
      )
    (1.upto 4).each do |y|
      selected_item = item_array[rand(5..(item_array.length - 1))]
      BlendingRecipeDetail.create_object(
         :blending_recipe_id => blending_recipe.id,
         :item_id => selected_item.id,
         :amount => 1
        )
    end
    if blending_recipe.errors.size == 0 
      blending_recipe.reload
      blending_recipe_array << blending_recipe
    end
  end
  
  blanket_order_array = []
  (1.upto 10).each do |x|
    selected_warehouse = warehouse_array[rand(0..(warehouse_array.length - 1))]
    selected_contact = customer_array[rand(0..(customer_array.length - 1))]
   
    blanket_order = BlanketOrder.create_object(
        :contact_id => selected_contact.id,
        :warehouse_id => selected_warehouse.id,
        :order_date => DateTime.now,
        :production_no => "Produc #{x}",
        :has_due_date => true,
        :due_date =>DateTime.now,
      )
    (1.upto 4).each do |y|
      selected_blanket = blanket_array[rand(0..(blanket_array.length - 1))]
      BlanketOrderDetail.create_object(
          :blanket_order_id => blanket_order.id,
          :blanket_id => selected_blanket.id,
          :quantity => 10 
        )
    end
    if blanket_order.errors.size == 0 
      blanket_order.confirm_object(:confirmed_at => DateTime.now)
      blanket_order.reload
      blanket_order_array << blanket_order
    end
  end
  
  roller_identification_array = []
  (1.upto 10).each do |x|
    selected_warehouse = warehouse_array[rand(0..(warehouse_array.length - 1))]
    selected_contact = customer_array[rand(0..(customer_array.length - 1))]
   
    roller_identification = RollerIdentificationForm.create_object(
        :warehouse_id =>selected_warehouse.id,
        :contact_id => selected_contact.id,
        :is_in_house => true,
        :amount => 4,
        :identified_date => DateTime.now,
        :nomor_disasembly => "no diss #{x}"
      )
    (1.upto 4).each do |y|
      selected_core_builder = core_builder_array[rand(0..(core_builder_array.length - 1))]
      selected_roller_type = roller_type_array[rand(0..(roller_type_array.length - 1))]
      selected_machine = machine_array[rand(0..(machine_array.length - 1))]
      RollerIdentificationFormDetail.create_object(
          :roller_identification_form_id => roller_identification.id,
          :detail_id => y,
          :material_case => MATERIAL_CASE[:new],
          :core_builder_id => selected_core_builder.id,
          :roller_type_id => selected_roller_type.id,
          :machine_id => selected_machine.id,
          :repair_request_case => REPAIR_REQUEST_CASE[:all],
          :roller_no => "rollerNo #{x} #{y}",
          :rd => BigDecimal("10"),
          :cd => BigDecimal("10"),
          :rl => BigDecimal("10"),
          :wl => BigDecimal("10"),
          :tl => BigDecimal("10"),
          :gl => BigDecimal("10"),
          :groove_amount => BigDecimal("10"),
          :groove_length => BigDecimal("10"), 
        )
    end
    if roller_identification.errors.size == 0 
      roller_identification.confirm_object(:confirmed_at => DateTime.now)
      roller_identification.reload
      roller_identification_array << roller_identification
    end
  end
  
  recovery_order_array = []
  (1.upto 10).each do |x|
    selected_warehouse = warehouse_array[rand(0..(warehouse_array.length - 1))]
    selected_contact = customer_array[rand(0..(customer_array.length - 1))]
    selected_roller_identification = roller_identification_array[rand(0..(roller_identification_array.length - 1))]
   
    recovery_order = RecoveryOrder.create_object(
        :roller_identification_form_id => selected_roller_identification.id,
        :warehouse_id => selected_warehouse.id,
        :code => "Code RIF #{x}",
        :has_due_date => true,
        :due_date => DateTime.now,
      )
    (1.upto 4).each do |y|
      selected_roller_identification_detail = 
      selected_roller_identification.roller_identification_form_details[rand(0..(selected_roller_identification.roller_identification_form_details.length - 1))]
      selected_roller_builder = roller_builder_array[rand(0..(roller_builder_array.length - 1))]
      RecoveryOrderDetail.create_object(
          :recovery_order_id => recovery_order.id,
          :roller_identification_form_detail_id => selected_roller_identification_detail.id,
          :roller_builder_id => selected_roller_builder.id,
          :core_type_case => CORE_TYPE_CASE[:r],
        )
    end
    if recovery_order.errors.size == 0 
      recovery_order.confirm_object(:confirmed_at => DateTime.now)
      recovery_order.reload
      recovery_order_array << recovery_order
    end
  end
  
  blending_work_order_array = []
  (1.upto 10).each do |x|
    selected_warehouse = warehouse_array[rand(0..(warehouse_array.length - 1))]
    selected_blending_recipe = blending_recipe_array[rand(0..(blending_recipe_array.length - 1))]
    blending_work_order = BlendingWorkOrder.create_object(
        :blending_recipe_id => selected_blending_recipe.id,
        :warehouse_id => selected_warehouse.id,
        :description => "desc #{x}",
        :blending_date => DateTime.now,
        :code => "Code Bwo #{x}"
      )
    if blending_work_order.errors.size == 0 
      blending_work_order.confirm_object(:confirmed_at => DateTime.now)
      blending_work_order.reload
      blending_work_order_array << blending_work_order
    end
  end
  
  
  
end
  
