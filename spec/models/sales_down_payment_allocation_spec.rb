require 'spec_helper'

describe SalesDownPaymentAllocation do
  before(:each) do
      
       
    @wrh_1 = Warehouse.create_object(
      :name => "whname_1" ,
      :description => "description_1",
      :code => "code_1"
      )
    
    @wrh_2 = Warehouse.create_object(
      :name => "name_2" ,
      :description => "description_1",
      :code => "code_2"
      ) 
      
     @ep_1 = Employee.create_object(
      :name => "name1",
      :description => "description_1",
      :contact_no => "contact_no_1",
      :address => "address_1",
      :email => "email_1",
      ) 
    
    @cg_1 = ContactGroup.create_object(
      :name => "Group1" ,
      :description => "Description1"
      )
    
    @ct_1 = Contact.create_object(
      :name => "name_1" ,
      :address => "address_1",
      :delivery_address => "delivery_address_1",
      :description => "description_1",
      :npwp => "npwp_1" ,
      :contact_no => "9928321",
      :pic => "pic_1",
      :pic_contact_no => "1232133",
      :email => "email1@email.com",
      :is_taxable => true,
      :tax_code => TAX_CODE[:code_01],
      :contact_type => CONTACT_TYPE[:supplier],
      :default_payment_term => 30,
      :nama_faktur_pajak => "nama_faktur_pajak_1",
      :contact_group_id => @cg_1.id
      )

    @ct_2 = Contact.create_object(
      :name => "name_2" ,
      :address => "address_2",
      :delivery_address => "delivery_address_2",
      :description => "description_2",
      :npwp => "npwp_2" ,
      :contact_no => "9219312",
      :pic => "pic_2",
      :pic_contact_no => "123242133",
      :email => "email2@email.com",
      :is_taxable => true,
      :tax_code => TAX_CODE[:code_01],
      :contact_type => CONTACT_TYPE[:supplier],
      :default_payment_term => 30,
      :nama_faktur_pajak => "nama_faktur_pajak_1",
      :contact_group_id => @cg_1.id
      )
    
   
      
    @exc_1 = Exchange.create_object(
      :name => "IDR1",
      :description => "description_1",
      )
  
    @exc_2 = Exchange.create_object(
      :name => "USD",
      :description => "description_2",
      )
      
    @exr_1 = ExchangeRate.create_object(
      :exchange_id => @exc_1.id,
      :ex_rate_date => DateTime.now,
      :rate => BigDecimal("1")
      )
    
    @exr_2 = ExchangeRate.create_object(
      :exchange_id => @exc_2.id,
      :ex_rate_date => DateTime.now,
      :rate => BigDecimal("1")
      )
    
    @coa_1 = Account.create_object(
      :code => "1110101",
      :name => "KAS 212",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
      )

    @coa_2 = Account.create_object(
      :code => "111220101",
      :name => "BANK 12",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:beban_usaha][:code]).id
      )
      
    @itp_1 = ItemType.create_object(
      :name => "ItemType_1" ,
      :description => "Description1",
      :account_id => @coa_1.id
      )
    
    @sbp_1 = SubType.create_object(
      :name => "SubType_1" ,
      :item_type_id => @itp_1.id
      )
     
    @uom_1 = Uom.create_object(
      :name => "Uom_1" ,
      ) 
    
    @item_1 = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku1",
      :name => "itemname1",
      :description => "description_1",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("10"),
      :selling_price => BigDecimal("1000"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )
    
    @sa_1 = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => DateTime.now,
      :description => @description_1
      )
     
    @sad_1 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @item_1.id,
      :price => BigDecimal("1000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
    
    @so_1 = SalesOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :sales_date => DateTime.now,
      :nomor_surat => "nomor_surat_1",
      :exchange_id => @exc_1.id
      )
      
    @sod_1 = SalesOrderDetail.create_object(
      :sales_order_id => @so_1.id,
      :item_id => @item_1.id,
      :amount => BigDecimal("10"),
      :price => BigDecimal("10000"),
      :is_service => true
      )
    
    @so_2 = SalesOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :sales_date => DateTime.now,
      :nomor_surat => "nomor_surat_2",
      :exchange_id => @exc_1.id
      )
    
    @sa_1.confirm_object(:confirmed_at => DateTime.now)
    
    @so_1.confirm_object(:confirmed_at => DateTime.now) 
    
    @dor = DeliveryOrder.create_object(
        :warehouse_id => @wrh_1.id,
        :delivery_date => DateTime.now,
        :nomor_surat => "nomor_surat",
        :sales_order_id => @so_1.id,
        )
    
    @dord_1 = DeliveryOrderDetail.create_object(
        :delivery_order_id => @dor.id,
        :sales_order_detail_id => @sod_1.id,
        :amount => BigDecimal("10"),
        )
    
    @dor.confirm_object(:confirmed_at => DateTime.now)
  
    @si_1 = SalesInvoice.create_object(
      :delivery_order_id => @dor.id,
      :invoice_date => DateTime.now,
      :nomor_surat => "123123",
      :description => "description",
      :due_date => DateTime.now
      )
    @sid_1 = SalesInvoiceDetail.create_object(
      :sales_invoice_id => @si_1.id,
      :delivery_order_detail_id => @dord_1.id,
      :amount => BigDecimal("10"),
      )
    @si_1.reload
    @si_1.confirm_object(:confirmed_at => DateTime.now)
    
    @receivable = Receivable.where(
      :source_id => @si_1.id,
      :source_class => @si_1.class.to_s
      ).first
      
    @down_payment_date_1 = DateTime.now
    @down_payment_date_2 = DateTime.now + 1.days
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days
    @total_amount_1 = BigDecimal("10000")
    @total_amount_2 = BigDecimal("20000")
    @description_1 = "desc"
    @allocation_date_1 = DateTime.now
    @allocation_date_2 = DateTime.now + 1.days
    @rate_to_idr_1 = BigDecimal("1")
    @rate_to_idr_1 = BigDecimal("10")
    @rate_1 = BigDecimal("1")
    @rate_2 = BigDecimal("10")
    @amount_paid_1 = BigDecimal("50000")
    @sdp = SalesDownPayment.create_object(
        :contact_id => @ct_1.id,
        :exchange_id => @exc_1.id,
        :down_payment_date => @down_payment_date_1,
        :due_date => @due_date_1,
        :total_amount => @total_amount_1 
        )
    @sdp.confirm_object(:confirmed_at => DateTime.now)
    
    
  end
  
  context "Create SalesDownPaymentAllocation" do
    before(:each) do
      @pdpa = SalesDownPaymentAllocation.create_object(
        :contact_id => @ct_1.id,
        :payable_id => @sdp.payable_id,
        :allocation_date => @allocation_date_1,
        :rate_to_idr => @rate_to_idr_1,
        )
    end
    
    it "should create SalesDownPaymentAllocation" do
      @pdpa.errors.size.should == 0
    end
    
    context "Create SalesDownPaymentAllocationDetail" do
      before(:each) do
        @pdpad = SalesDownPaymentAllocationDetail.create_object(
          :sales_down_payment_allocation_id => @pdpa.id,
          :receivable_id => @receivable.id,
          :description => @description_1,
          :amount_paid => @amount_paid_1,
          :rate => @rate_1
          )
      end
      
      it "should create SalesDownPaymentAllocationDetail" do
        @pdpad.errors.size.should == 0
      end
      
      context "Confirm SalesDownPaymentAllocation" do
        before(:each) do
          @pdpa.reload
          @pdpa.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm SalesDownPaymentAllocation" do
          @pdpa.errors.size.should == 0
          @pdpa.is_confirmed.should == true
        end
        
        it "should create TransactionData" do
           td = TransactionData.where(
            :transaction_source_type => @pdpa.class.to_s,
            :transaction_source_id => @pdpa.id
            )
          td.count.should == 1
          td.first.is_confirmed.should == true
        end
        
        context "Unconfirm SalesDownPaymentAllocation" do
          before(:each) do
            @pdpa.reload
            @pdpa.unconfirm_object
          end
        end
      end
      
      
    end
  end
end
