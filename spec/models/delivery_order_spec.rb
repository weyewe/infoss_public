require 'spec_helper'

describe DeliveryOrder do
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
      :code => "1110101",
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
    
#     @sod_2 = SalesOrderDetail.create_object(
#       :sales_order_id => @so_2.id,
#       :item_id => @item_1.id,
#       :amount => BigDecimal("10"),
#       :price => BigDecimal("10000")
#       )
    
    
#     @so_2.confirm_object(:confirmed_at => DateTime.now)   
    @delivery_date_1 = DateTime.now
    @delivery_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
  end
  
  it "should change Item Pending Receival to 10" do
    item = Item.where(:id => @sod_1.item_id)
    item.first.pending_delivery.should == 10
  end
  
  it "should not create DeliveryOrder if warehouse_id is not valid" do
    dor = DeliveryOrder.create_object(
      :warehouse_id => 123123,
      :delivery_date => @delivery_date_1,
      :nomor_surat => @nomor_surat_1,
      :sales_order_id => @so_1.id,
      )
    dor.errors.size.should_not == 0
    dor.should_not be_valid
  end
  
  it "should not create DeliveryOrder if delivery_date is not valid" do
    dor = DeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => nil,
      :nomor_surat => @nomor_surat_1,
      :sales_order_id => @so_1.id,
      )
    dor.errors.size.should_not == 0
    dor.should_not be_valid
  end
  
  it "should not create DeliveryOrder if nomor_surat is not valid" do
    dor = DeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => @delivery_date_1,
      :nomor_surat => nil,
      :sales_order_id => @so_1.id,
      )
    dor.errors.size.should_not == 0
    dor.should_not be_valid
  end

  it "should not create DeliveryOrder if sales_order_id is not valid" do
    dor = DeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => @delivery_date_1,
      :nomor_surat => @nomor_surat_1,
      :sales_order_id => 213123,
      )
    dor.errors.size.should_not == 0
    dor.should_not be_valid
  end
  
  context "Create DeliveryOrder" do
    before(:each) do
      @dor = DeliveryOrder.create_object(
        :warehouse_id => @wrh_1.id,
        :delivery_date => @delivery_date_1,
        :nomor_surat => @nomor_surat_1,
        :sales_order_id => @so_1.id,
        )
    end
    
    it "should create DeliveryOrder" do
      @dor.errors.size.should == 0
      @dor.should be_valid
    end
    
    it "should update DeliveryOrder" do
      @dor.update_object(
        :warehouse_id => @wrh_2.id,
        :delivery_date => @delivery_date_2,
        :nomor_surat => @nomor_surat_2,
        :sales_order_id => @so_2.id,
      )
      @dor.warehouse_id.should == @wrh_2.id
      @dor.delivery_date.should == @delivery_date_2
      @dor.nomor_surat.should == @nomor_surat_2
      @dor.sales_order_id.should == @so_2.id
    end
    
    it "should not update DeliveryOrder if warehouse_id is not valid" do
      @dor.update_object(
        :warehouse_id => 1232132,
        :delivery_date => @delivery_date_2,
        :nomor_surat => @nomor_surat_2,
        :sales_order_id => @so_2.id,
      )
      @dor.errors.size.should_not == 0
      @dor.should_not be_valid
    end
    
    it "should not update DeliveryOrder if delivery_date is not valid" do
      @dor.update_object(
        :warehouse_id => @wrh_2.id,
        :delivery_date => nil,
        :nomor_surat => @nomor_surat_2,
        :sales_order_id => @so_2.id,
      )
      @dor.errors.size.should_not == 0
      @dor.should_not be_valid
    end
    
    it "should not update DeliveryOrder if nomor_surat is not valid" do
      @dor.update_object(
        :warehouse_id => @wrh_2.id,
        :delivery_date => @delivery_date_2,
        :nomor_surat => nil,
        :sales_order_id => @so_2.id,
      )
      @dor.errors.size.should_not == 0
      @dor.should_not be_valid
    end
    
    it "should not update DeliveryOrder if sales_order_id is not valid" do
      @dor.update_object(
        :warehouse_id => @wrh_2.id,
        :delivery_date => @delivery_date_2,
        :nomor_surat => @nomor_surat_2,
        :sales_order_id => 123123,
      )
      @dor.errors.size.should_not == 0
      @dor.should_not be_valid
    end 
    
    it "should delete DeliveryOrder" do
      @dor.delete_object
      @dor.errors.size.should == 0
    end
    
    context "Create TemporaryDeliveryOrder and Confirm DeliveryOrder from TemporaryDeliveryOrder" do
      before(:each) do
        @tdo = TemporaryDeliveryOrder.create_object(
          :warehouse_id => @wrh_1.id,
          :delivery_date => @delivery_date_1,
          :nomor_surat => @nomor_surat_1,
          :delivery_order_id => @dor.id,
          )
        @tdod = TemporaryDeliveryOrderDetail.create_object(
          :temporary_delivery_order_id => @tdo.id,
          :sales_order_detail_id => @sod_1.id,
          :amount => 10
          )
        @tdo.confirm_object(:confirmed_at => DateTime.now)
        @dor.confirm_object_from_temporary_delivery_order(:confirmed_at => DateTime.now)
      end
      
      it "should create DeliveryOrderDetail" do
        @dor.delivery_order_details.count.should == 1  
      end
      
      it "should confirm DeliveryOrder" do
        @dor.errors.size.should == 0
        @dor.is_confirmed.should == true
      end
      
    end
    context "Create DeliveryOrderDetail" do
      before(:each) do
      @dord_1 = DeliveryOrderDetail.create_object(
        :delivery_order_id => @dor.id,
        :sales_order_detail_id => @sod_1.id,
        :amount => BigDecimal("10"),
        )
      end
      
      it "should create DeliveryOrderDetail" do
        @dord_1.should be_valid
        @dord_1.errors.size.should == 0
        
      end
      
      it "should not update DeliveryOrder if have details" do
        @dor.update_object(
          :warehouse_id => @wrh_2.id,
          :delivery_date => @delivery_date_2,
          :nomor_surat => @nomor_surat_2,
          :sales_order_id => @so_2.id,
        )
        @dor.errors.size.should_not == 0
      end

      it "should not delete DeliveryOrder if have details" do
        @dor.delete_object
        @dor.errors.size.should_not == 0
      end
      
      context "Confirm DeliveryOrder" do
        before(:each) do
          @dor.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm DeliveryOrder" do
          @dor.is_confirmed.should be true
        end
        
        it "should create 1 TransactionalData" do
         td = TransactionData.where(
           :transaction_source_type => @dor.class.to_s,
            :transaction_source_id => @dor.id
            )
          td.count.should == 1
        end
        
        it "should change Item pending_delivery amount to 0" do
          item = Item.where(:id => @dord_1.item_id)
          item.count.should == 1
          item.first.pending_delivery.should == 0
        end
        
        it "should change Item amount to 0" do
          item = Item.where(:id => @dord_1.item_id)
          item.count.should == 1
          item.first.amount.should == 0
        end
        
        it "should set totalCOGS to 10000" do
          @dor.total_cogs.should == 10000
        end
        
        it "should set SalesOrder is_receival_completed to true" do
          @so_1.reload
          @so_1.is_delivery_completed.should == true
        end
        
        it "should create 2 stockmutation" do
          sm = StockMutation.where(:source_id => @dor.id,:source_class => @dor.class.to_s)
          sm.count.should == 2
        end
        
        it "should not double confirm" do
          @dor.confirm_object(:confirmed_at => DateTime.now)
          @dor.errors.size.should_not == 0
        end
        
        context "Unconfirm DeliveryOrder" do
          before(:each) do
            @dor.unconfirm_object
          end
          
          it "should unconfirm DeliveryOrder" do
            @dor.is_confirmed.should be false
            @dor.confirmed_at.should == nil
            @dor.errors.size.should == 0
          end
          
          it "should change Item pending_delivery amount to 10" do
            item = Item.where(:id => @dord_1.item_id)
            item.first.pending_delivery.should == 10
          end
          
          it "should change Item amount to 0" do
            item = Item.where(:id => @dord_1.item_id)
            item.first.amount.should == 10
          end
          
          it "should set SalesOrder is_receival_completed to false" do
            @so_1.reload
            @so_1.is_delivery_completed.should == false
          end
          
          it "should delete StockMutation" do
            sm = StockMutation.where(:source_id => @dor.id,:source_class => @dor.class.to_s)
            sm.count.should == 0
          end
          
          it "should not unconfirm again" do
            @dor.unconfirm_object
            @dor.errors.size.should_not == 0
          end
          
        end
      end      
    end
  end
end
