require 'spec_helper'

describe VirtualOrderClearance do
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
    
   @vo_1 = VirtualOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :order_date => DateTime.now,
      :nomor_surat => "nomor_surat_1",
      :exchange_id => @exc_1.id
      )
  
   @vod_1 = VirtualOrderDetail.create_object(
      :virtual_order_id => @vo_1.id,
      
      :item_id => @item_1.id,
      :amount => BigDecimal("10"),
      :price => BigDecimal("10000"),
      :is_service => true
      )
    
   @vo_2 = VirtualOrder.create_object(
      :contact_id => @ct_1.id,
      :employee_id => @ep_1.id,
      :order_date => DateTime.now,
      :nomor_surat => "nomor_surat_2",
      :exchange_id => @exc_1.id
      )
    
    @vdo_1 = VirtualDeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => DateTime.now,
      :nomor_surat => "nomor_surat",
      :virtual_order_id => @vo_1.id,
      )
    
    @vdod_1 = VirtualDeliveryOrderDetail.create_object(
      :virtual_delivery_order_id => @vdo_1.id,
      :virtual_order_detail_id => @vod_1.id,
      :amount => 5
      )
    
    @vdo_2 = VirtualDeliveryOrder.create_object(
      :warehouse_id => @wrh_1.id,
      :delivery_date => DateTime.now,
      :nomor_surat => "nomor_surat",
      :virtual_order_id => @vo_1.id,
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
    @vo_1.confirm_object(:confirmed_at => DateTime.now) 
    @vdo_1.confirm_object(:confirmed_at => DateTime.now) 
    @clearance_date_1 = DateTime.now
    @clearance_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
  end
  
  it "should not create VirtualOrderClearance if virtual_delivery_order_id is not valid" do
    voc = VirtualOrderClearance.create_object(
      :virtual_delivery_order_id => 123213213,
      :clearance_date => @clearance_date_1
      )
      voc.errors.should_not == 0
      voc.should_not be_valid
  end
  
  it "should not create VirtualOrderClearance if clearance_date is not valid" do
    voc = VirtualOrderClearance.create_object(
      :virtual_delivery_order_id => @vdo_1.id,
      :clearance_date => nil
      )
      voc.errors.should_not == 0
      voc.should_not be_valid
  
  end
  
  context "Create VirtualOrderClearance" do
    before(:each) do
    @voc = VirtualOrderClearance.create_object(
        :virtual_delivery_order_id =>  @vdo_1.id,
        :clearance_date => @clearance_date_1
        )
    
    end
    
    it "should create VirtualOrderClearance" do
        @voc.errors.size.should == 0
    end
    
    it "should update VirtualOrderClearance" do
      @voc.update_object(
        :virtual_delivery_order_id => @vdo_2.id,
        :clearance_date => @clearance_date_2
        )
        @voc.errors.size.should  == 0
        @voc.virtual_delivery_order_id.should == @vdo_2.id
        @voc.clearance_date.should == @clearance_date_2
    end
    
    it "should not update VirtualOrderClearance if virtual_delivery_order_id is not valid" do
       @voc.update_object(
        :virtual_delivery_order_id => 123123213,
        :clearance_date => @clearance_date_2
        )
        @voc.errors.size.should_not  == 0
        @voc.should_not be_valid
    end
    
    it "should not update VirtualOrderClearance if clearance_date is not valid" do
       @voc.update_object(
        :virtual_delivery_order_id => @vdo_2.id,
        :clearance_date => nil
        )
        @voc.errors.size.should_not  == 0
        @voc.should_not be_valid
    end
    
    context "Create VirtualOrderClearanceDetail with no waste" do
        before(:each) do
            @vocd = VirtualOrderClearanceDetail.create_object(
                :virtual_order_clearance_id => @voc.id,
                :virtual_delivery_order_detail_id => @vdod_1.id,
                :amount => 5,
                :selling_price => BigDecimal("1000")
                )
        end
        
        it "should create VirtualOrderClearanceDetail" do
            @vocd.errors.size.should == 0
        end
        
        it "should not update VirtualOrderClearance if have detail" do
          @voc.update_object(
            :virtual_delivery_order_id => @vdo_2.id,
            :clearance_date => @clearance_date_2
            )
            @voc.errors.size.should_not  == 0
        end
        
        
        it "should not delete VirtualOrderClearance if have detail" do
          @voc.delete_object
          @voc.errors.size.should_not == 0
        end
     
        context "Confirm VirtualOrderClearance" do
            before(:each) do
              @voc.confirm_object(:confirmed_at => DateTime.now)
            end
            
            it "should confirm VirtualOrderClearance" do
              @voc.errors.size.should == 0
              @voc.is_confirmed.should == true
            end
            
            it "should create 1 stock mutation" do
              sm = StockMutation.where(:source_id => @voc.id,:source_class => @voc.class.to_s)
              sm.count.should == 1
            end
            
            it "should set VirtualDeliveryOrder is_reconciled to true" do
              @voc.virtual_delivery_order.is_reconciled.should == true
            end
                                
            context "Unconfirm VirtualOrderClearance" do
                before(:each) do
                  @voc.unconfirm_object
                end
                
                it "should unconfirm VirtualOrderClearance" do
                  @voc.is_confirmed.should == false
                end
                
                it "should delete stock mutation" do
                  sm = StockMutation.where(:source_id => @voc.id,:source_class => @voc.class.to_s)
                  sm.count.should == 0
                end
                
                it "should set virtual_delivery_order is_reconciled to false"do
                  @voc.virtual_delivery_order.is_reconciled.should == false
                end
            end
            
        end
    end
    
    context "Create VirtualOrderClearanceDetail with waste" do
      before(:each) do
            @vocd = VirtualOrderClearanceDetail.create_object(
                :virtual_order_clearance_id => @voc.id,
                :virtual_delivery_order_detail_id => @vdod_1.id,
                :amount => 4,
                :selling_price => BigDecimal("1000")
                )
        end
        
        it "should create VirtualOrderClearanceDetail" do
            @vocd.errors.size.should == 0
        end
        
        it "should not update VirtualOrderClearance if have detail" do
          @voc.update_object(
            :virtual_delivery_order_id => @vdo_2.id,
            :clearance_date => @clearance_date_2
            )
            @voc.errors.size.should_not  == 0
        end
        
        
        it "should not delete VirtualOrderClearance if have detail" do
          @voc.delete_object
          @voc.errors.size.should_not == 0
        end
     
        context "Confirm VirtualOrderClearance" do
            before(:each) do
              @voc.confirm_object(:confirmed_at => DateTime.now)
            end
            
            it "should confirm VirtualOrderClearance" do
              @voc.errors.size.should == 0
              @voc.is_confirmed.should == true
            end
            
            it "should create 2 stock mutation" do
              sm = StockMutation.where(:source_id => @voc.id,:source_class => @voc.class.to_s)
              sm.count.should == 2
            end
            
            it "should set VirtualDeliveryOrder is_reconciled to true" do
              @voc.virtual_delivery_order.is_reconciled.should == true
            end
                                
            context "Unconfirm VirtualOrderClearance" do
                before(:each) do
                  @voc.unconfirm_object
                end
                
                it "should unconfirm VirtualOrderClearance" do
                  @voc.is_confirmed.should == false
                end
                
                it "should delete stock mutation" do
                  sm = StockMutation.where(:source_id => @voc.id,:source_class => @voc.class.to_s)
                  sm.count.should == 0
                end
                
                it "should set virtual_delivery_order is_reconciled to false"do
                  @voc.virtual_delivery_order.is_reconciled.should == false
                end
            end
            
        end
    end
  end
  
end
