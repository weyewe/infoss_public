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
     
    @itp_1 =  ItemType.where(:is_batched => true ).first
    
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
    
    
    @delivery_date_1 = DateTime.now
    @delivery_date_2 = DateTime.now + 1.days
    @nomor_surat_1 = "991.22"
    @nomor_surat_2 = "199.22"
  end
  
  it "should have 2 batched item_type" do
      ItemType.where(:is_batched => true ).count.should == 2 
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
     
    context "Create DeliveryOrderDetail" do
      before(:each) do
      @dord_1 = DeliveryOrderDetail.create_object(
        :delivery_order_id => @dor.id,
        :sales_order_detail_id => @sod_1.id,
        :amount => BigDecimal("10"),
        )
      end 
 
      
      context "Confirm DeliveryOrder" do
        before(:each) do
          @dor.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm DeliveryOrder" do
          @dor.is_confirmed.should be true
        end
        
        it "should create one batch_source from delivery order detail" do
            BatchSource.where(
                :item_id => @dord_1.item_id, 
                :source_class => @dord_1.class.to_s,
                :source_id => @dord_1.id 
                ).count.should == 1 
                
            batch_source = BatchSource.where(
                :item_id => @dord_1.item_id, 
                :source_class => @dord_1.class.to_s,
                :source_id => @dord_1.id 
                ).first
                
            batch_source.status == ADJUSTMENT_STATUS[:deduction]
                
            batch_source.unallocated_amount.should == batch_source.amount 
        end
        
     
        
        context "Unconfirm DeliveryOrder" do
          before(:each) do
            @dor.unconfirm_object
          end
          
          it "should delete batch source" do
              BatchSource.where(
                :item_id => @dord_1.item_id, 
                :source_class => @dord_1.class.to_s,
                :source_id => @dord_1.id 
                ).count.should == 0
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
