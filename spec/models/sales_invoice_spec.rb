require 'spec_helper'

describe SalesInvoice do
  
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
    :sic => "sic_1",
    :sic_contact_no => "1232133",
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
    :sic => "sic_2",
    :sic_contact_no => "123242133",
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
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
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
    
    @invoice_date_1 = DateTime.now
    @invoice_date_2 = DateTime.now + 1.days
    @due_date_1 = DateTime.now
    @due_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
    @description_1 = "description_1"
    @description_2 = "description_2"
  end
  
  it "should not create SalesInvoice if delivery_order_id is not valid" do
    si = SalesInvoice.create_object(
      :delivery_order_id => 123123,
      :invoice_date => @invoice_date_1,
      :nomor_surat => @nomor_surat_1,
      :description => @description_1,
      :due_date => @due_date_1
      )
    si.errors.size.should_not == 0
    si.should_not be_valid
  end
  
it "should not create SalesInvoice if invoice_date is not valid" do
    si = SalesInvoice.create_object(
      :delivery_order_id => @dor.id,
      :invoice_date => nil,
      :nomor_surat => @nomor_surat_1,
      :description => @description_1,
      :due_date => @due_date_1
      )
    si.errors.size.should_not == 0
    si.should_not be_valid
  end
  
  it "should not create SalesInvoice if nomor_surat is not valid" do
    si = SalesInvoice.create_object(
      :delivery_order_id => @dor.id,
      :invoice_date => @invoice_date_1,
      :nomor_surat => nil,
      :description => @description_1,
      :due_date => @due_date_1
      )
    si.errors.size.should_not == 0
    si.should_not be_valid
  end

  
  context "Create SalesInvoice" do
    before(:each) do
      @si = SalesInvoice.create_object(
        :delivery_order_id => @dor.id,
        :invoice_date => @invoice_date_1,
        :nomor_surat => @nomor_surat_1,
        :description => @description_1,
        :due_date => @due_date_1
        )
    end
    
    it "should create SalesInvoice" do
      @si.should be_valid
      @si.errors.size.should == 0
      
    end
    
    it "should update SalesInvoice" do
      @si.update_object(
        :delivery_order_id => @dor.id,
        :invoice_date => @invoice_date_2,
        :nomor_surat => @nomor_surat_2,
        :description => @description_2,
        :due_date => @due_date_2
      )
      @si.delivery_order_id.should == @dor.id
      @si.invoice_date.should == @invoice_date_2
      @si.nomor_surat.should == @nomor_surat_2
      @si.description.should == @description_2
      @si.due_date.should == @due_date_2
    end
    
    it "should not update SalesInvoice if delivery_order_id is not valid" do
      @si.update_object(
        :delivery_order_id => 1231231,
        :invoice_date => @invoice_date_2,
        :nomor_surat => @nomor_surat_2,
        :description => @description_2,
        :due_date => @due_date_2
      )
      @si.errors.size.should_not == 0
      @si.should_not be_valid
    end
    
    it "should not update SalesInvoice if invoice_date is not valid" do
      @si.update_object(
        :delivery_order_id => @dor.id,
        :invoice_date => nil,
        :nomor_surat => @nomor_surat_2,
        :description => @description_2,
        :due_date => @due_date_2
      )
      @si.errors.size.should_not == 0
      @si.should_not be_valid
    end
    
    it "should not update SalesInvoice if nomor_surat is not valid" do
      @si.update_object(
        :delivery_order_id => @dor.id,
        :invoice_date => @invoice_date_2,
        :nomor_surat => nil,
        :description => @description_2,
        :due_date => @due_date_2
      )
      @si.errors.size.should_not == 0
      @si.should_not be_valid
    end
    
    it "should delete SalesInvoice" do
      @si.delete_object
      @si.errors.size.should == 0
    end
    
    context "Create SalesInvoiceDetail" do
      before(:each) do
      @sid_1 = SalesInvoiceDetail.create_object(
        :sales_invoice_id => @si.id,
        :delivery_order_detail_id => @dord_1.id,
        :amount => BigDecimal("10"),
        )
        @si.reload
      end
      
      it "should create SalesInvoiceDetail" do
        @sid_1.should be_valid
        @sid_1.errors.size.should == 0
        
      end
    
      
      it "should not update SalesInvoice if have details" do
        @si.update_object(
          :delivery_order_id => @dor.id,
          :invoice_date => @invoice_date_2,
          :nomor_surat => @nomor_surat_2,
          :description => @description_2,
          :due_date => @due_date_2
        )
        @si.errors.size.should_not == 0
      end

      it "should not delete SalesInvoice if have details" do
        @si.delete_object
        @si.errors.size.should_not == 0
      end
      
      context "Confirm SalesInvoice" do
        before(:each) do
          @si.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm SalesInvoice" do
          @si.is_confirmed.should be true
        end
        
        it "should create TransactionData" do
          td = TransactionData.where(
            :transaction_source_type => @si.class.to_s,
            :transaction_source_id => @si.id
            )
          td.count.should == 1
        end
        
        it "should create 1 receivable" do
          receivable = Receivable.where(
            :source_id => @si.id,
            :source_class => @si.class.to_s
            )
          receivable.count.should == 1
          receivable.first.amount.should == @si.amount_receivable
        end
        
        it "should set Purchase_receival is_invoice_completed to true" do
          @dor.reload
          @dor.is_invoice_completed.should == true
        end
        
        it "should not double confirm" do
          @si.confirm_object(:confirmed_at => DateTime.now)
          @si.errors.size.should_not == 0
        end
        
        context "Unconfirm SalesInvoice" do
          before(:each) do
            @si.unconfirm_object
          end
          
          it "should unconfirm SalesInvoice" do
            @si.is_confirmed.should be false
            @si.confirmed_at.should == nil
            @si.errors.size.should == 0
          end
          
          it "should set Purchase_receival is_invoice_completed  to false" do
            @dor.reload
            @dor.is_invoice_completed.should == false
          end
          
          it "should delete receivable" do
            receivable = Receivable.where(
            :source_id => @si.id,
            :source_class => @si.class.to_s
            )
            receivable.count.should == 0
          end
          
          it "should not unconfirm again" do
            @si.unconfirm_object
            @si.errors.size.should_not == 0
          end
          
        end
      end      
    end
  end
end

