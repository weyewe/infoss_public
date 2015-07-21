require 'spec_helper'

describe Closing do
  before(:each) do
    @ep_1 = Employee.create_object(
      :name => "name1",
      :description => "description_1",
      :contact_no => "contact_no_1",
      :address => "address_1",
      :email => "email_1",
      ) 
    
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

    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id,
      :normal_balance => NORMAL_BALANCE[:credit]
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
    
    @cb_1 = CashBank.create_object(
      :name => "awesome name" ,
      :description => "ehaufeahifi heaw",
      :is_bank => true ,
      :exchange_id => @exc_1.id
      )
    
    @cb_2 = CashBank.create_object(
      :name => "awesome name2" ,
      :description => "ehaufeahifi heaw",
      :is_bank => false ,
      :exchange_id => @exc_1.id
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
    
    
    
    @receivable_1 = Receivable.where(
      :source_id => @si_1.id,
      :source_class => @si_1.class.to_s
      ).first
    
    @no_bukti_1 = "Nomor Bukti 1"
    @no_bukti_2 = "Nomor Bukti 2"
    @is_gbch_1 = true
    @is_gbch_2 = false
    @gbch_no_1 = "1234"
    @gbch_no_2 = "12345"
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days
    @pembulatan_1 = BigDecimal("1")
    @pembulatan_2 = BigDecimal("1")
    @status_pembulatan_1 = STATUS_PEMBULATAN[:debet]
    @status_pembulatan_2 = STATUS_PEMBULATAN[:kredit]
    @biaya_bank_1 = BigDecimal("1")
    @biaya_bank_2 = BigDecimal("1")
    @rate_to_idr_1 = BigDecimal("1")
    @rate_to_idr_2 = BigDecimal("1000")
    @receipt_date_1 = DateTime.now
    @receipt_date_2 = DateTime.now + 1.days

    @rv_1 = ReceiptVoucher.create_object(
      :no_bukti => @no_bukti_1,
      :is_gbch => @is_gbch_2,
      :gbch_no => @gbch_no_1,
      :due_date => @due_date_1,
      :pembulatan => @pembulatan_1,
      :status_pembulatan => @status_pembulatan_1,
      :biaya_bank => @biaya_bank_1,
      :rate_to_idr => @rate_to_idr_1,
      :receipt_date => @receipt_date_1,
      :contact_id =>  @ct_1.id,
      :cash_bank_id => @cb_1.id
      )
      
    @rvd_1 = ReceiptVoucherDetail.create_object(
      :receipt_voucher_id => @rv_1.id,
      :receivable_id => @receivable_1.id,
      :amount => BigDecimal("100000"),
      :amount_paid => BigDecimal("100000"),
      :pph_23 => BigDecimal("100"),
      :rate => BigDecimal("1")
      )
      
    @rv_1.reload  
    @rv_1.confirm_object(:confirmed_at => DateTime.now)
       
    end
    
    
  context "create Closing" do
    before(:each) do
      @cls = Closing.create_object(
        :period => 1,
        :year_period => 2,
        :beginning_period => DateTime.now - 1.years,
        :end_date_period => DateTime.now + 1.months,
        :is_year_closing => true
        )
    end
    
    it "check all " do
      @rv_1.errors.size.should == 0
      @si_1.errors.size.should == 0
      @cls.is_year_closing.should == true
    end
    
    it "should create detail" do
      @cls.closing_details.count.should == 3
    end
    
    context "confirm Closing" do
      before(:each) do
        @cls.close_object(:closed_at => DateTime.now)
      end
      
    
      it "should confirm Closing" do
        @cls.is_closed.should == true  
      end 
      
      context "unconfirm closing" do
        before(:each) do
          @cls.open_object
        end
        it "should unconfirm Closing" do
          @cls.is_closed.should == false
        end
      end
      
    end
end
end
