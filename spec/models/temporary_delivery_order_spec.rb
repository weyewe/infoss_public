require 'spec_helper'

describe TemporaryDeliveryOrder do
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
    
    @dor_1 = DeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => DateTime.now,
      :nomor_surat => "nomor_surat_1",
      :sales_order_id => @so_1.id,
      )
    
    @dor_2  = DeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => DateTime.now,
      :nomor_surat => "nomor_surat_2",
      :sales_order_id => @so_1.id,
      )
    
    @sa_1.confirm_object(:confirmed_at => DateTime.now)
    @so_1.confirm_object(:confirmed_at => DateTime.now) 
    @dor_1.confirm_object(:confirmed_at => DateTime.now) 
    @delivery_date_1 = DateTime.now
    @delivery_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
  end
  
  it "should not create temporary_delivery_order if nomor_surat not valid" do
    tdo = TemporaryDeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => @delivery_date_1,
      :nomor_surat => nil,
      :delivery_order_id => @dor_1.id,
      )
    tdo.errors.size.should_not == 0
    tdo.should_not be_valid
  end
  
  it "should not create temporary_delivery_order if warehouse_id not valid" do
    tdo = TemporaryDeliveryOrder.create_object(
      :warehouse_id => 11111112,
      :delivery_date => @delivery_date_1,
      :nomor_surat => @nomor_surat_1,
      :delivery_order_id => @dor_1.id,
      )
    tdo.errors.size.should_not == 0
    tdo.should_not be_valid
  end
  
  it "should not create temporary_delivery_order if delivery_date not valid" do
    tdo = TemporaryDeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => nil,
      :nomor_surat => @nomor_surat_1,
      :delivery_order_id => @dor_1.id,
      )
    tdo.errors.size.should_not == 0
    tdo.should_not be_valid
  end
  
  it "should not create temporary_delivery_order if delivery_order_id not valid" do
    tdo = TemporaryDeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => @delivery_date_1,
      :nomor_surat => @nomor_surat_1,
      :delivery_order_id => 21344,
      )
    tdo.errors.size.should_not == 0
    tdo.should_not be_valid
  end
  
  context "Create TemporaryDeliveryOrder" do
    before(:each) do
     @tdo = TemporaryDeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => @delivery_date_1,
      :nomor_surat => @nomor_surat_1,
      :delivery_order_id => @dor_1.id,
      )
    end
    
    it "should delete TemporaryDeliveryOrder" do
      @tdo.delete_object
      @tdo.errors.size.should == 0
    end
      
    it "should update TemporaryDeliveryOrder" do
      @tdo.update_object(
        :warehouse_id => @wrh_2.id,
        :delivery_date => @delivery_date_2,
        :nomor_surat => @nomor_surat_2,
        :delivery_order_id => @dor_2.id,
        )
      @tdo.should be_valid
      @tdo.errors.size.should == 0
      @tdo.warehouse_id.should ==  @wrh_2.id
      @tdo.delivery_date.should ==  @delivery_date_2
      @tdo.nomor_surat.should ==  @nomor_surat_2
      @tdo.delivery_order_id.should ==  @dor_2.id
      
    end
    
    it "should not update TemporaryDeliveryOrder if warehouse_id not valid" do
      @tdo.update_object(
        :warehouse_id => 213213,
        :delivery_date => @delivery_date_2,
        :nomor_surat => @nomor_surat_2,
        :delivery_order_id => @dor_2.id,
        )
      @tdo.errors.size.should_not == 0
    end
    
    it "should not update TemporaryDeliveryOrder if delivery_date not valid" do
      @tdo.update_object(
        :warehouse_id => @wrh_2.id,
        :delivery_date => nil,
        :nomor_surat => @nomor_surat_2,
        :delivery_order_id => @dor_2.id,
        )
      @tdo.errors.size.should_not == 0
    end
    
    it "should not update TemporaryDeliveryOrder if nomor_surat not valid" do
      @tdo.update_object(
        :warehouse_id => @wrh_2.id,
        :delivery_date => @delivery_date_2,
        :nomor_surat => nil,
        :delivery_order_id => @dor_2.id,
        )
      @tdo.errors.size.should_not == 0
    end
    
    it "should not update TemporaryDeliveryOrder if delivery_order_id not valid" do
      @tdo.update_object(
        :warehouse_id => @wrh_2.id,
        :delivery_date => @delivery_date_2,
        :nomor_surat => @nomor_surat_2,
        :delivery_order_id => 1232132,
        )
      @tdo.errors.size.should_not == 0
    end
    
    it "should not confirm if TemporaryDeliveryOrder has no detail" do
      @tdo.confirm_object(:confirmed_at => DateTime.now)
      @tdo.errors.size.should_not == 0
    end
    
    context "create TemporaryDeliveryOrderDetail" do
      before(:each) do
        @tdod = TemporaryDeliveryOrderDetail.create_object(
          :temporary_delivery_order_id => @tdo.id,
          :sales_order_detail_id => @sod_1.id,
          :amount => 5
          )
      end
      
      it "should create TemporaryDeliveryOrderDetail" do
        @tdod.errors.size.should == 0
        @tdod.should be_valid
      end
      
      context "confirm TemporaryDeliveryOrder" do
        before(:each) do
          @tdo.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm TemporaryDeliveryOrder" do
          @tdo.is_confirmed.should == true
        end
        
        it "should set item virtual_amount value to 5" do
          @item_1.reload
          @item_1.virtual.should == 5
        end
        
        it "should create StockMutation" do
          sm = StockMutation.where(:source_id => @tdo.id,:source_class => @tdo.class.to_s)
          sm.count.should == 1
        end
        
        it "cannot confirm if is_confirmed == true" do
          @tdo.confirm_object(:confirmed_at => DateTime.now)
          @tdo.errors.size.should_not == 0 
        end
        
        it "should not delete if already confirmed" do
          @tdo.delete_object
          @tdo.errors.size.should_not == 0
        end
        
        it "should set SalesOrderDetail.pending_delivery_amount to 5" do
          @sod_1.reload
          @sod_1.pending_delivery_amount.should == 5
        end
        
        context "Unconfirm TemporaryDeliveryOrder" do
          before(:each) do
            @tdo.unconfirm_object
          end
          
          it "should unconfirm TemporaryDeliveryOrder" do
            @tdo.is_confirmed.should == false
          end
          
          it "should set item virtual amount to 0" do
            @item_1.reload 
            @item_1.virtual.should == 0
          end
          
          it "should set SalesOrderDetail.pending_delivery_amount to 10" do
            @sod_1.reload
            @sod_1.pending_delivery_amount.should == 10
          end
          
          it "should delete StockMutation" do
            sm = StockMutation.where(:source_id => @tdo.id,:source_class => @tdo.class.to_s)
            sm.count.should == 0
          end
          
        end
      end
      
    end
  end
end
