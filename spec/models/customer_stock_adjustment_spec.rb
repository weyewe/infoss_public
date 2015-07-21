require 'spec_helper'

describe CustomerStockAdjustment do
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
    
    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
   
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
      :contact_type => CONTACT_TYPE[:customer],
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
      :contact_type => CONTACT_TYPE[:customer],
      :default_payment_term => 30,
      :nama_faktur_pajak => "nama_faktur_pajak_1",
      :contact_group_id => @cg_1.id
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
      :description => @description_1,
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
    @adjustment_date_1 = DateTime.now
    @adjustment_date_2 = DateTime.now + 1.days
    @description_1 = "Description1"
    @description_2 = "Description2"
  end

  it "should create CustomerStockAdjustment" do
    sa = CustomerStockAdjustment.create_object(
      :contact_id => @ct_1.id,
      :warehouse_id => @wrh_1.id,
      :adjustment_date => @adjustment_date_1,
      :description => @description_1
      )
    sa.errors.size.should == 0
    sa.should be_valid
  end
  
  it "should not create CustomerStockAdjustment if warehouse is not valid" do
    sa = CustomerStockAdjustment.create_object(
      :contact_id => @ct_1.id,
      :warehouse_id => 5123,
      :adjustment_date => @adjustment_date_1,
      :description => @description_1
      )
    sa.errors.size.should_not == 0
    sa.should_not be_valid
  end
  
  it "should not create CustomerStockAdjustment if adjustment_date is not valid" do
    sa = CustomerStockAdjustment.create_object(
      :contact_id => @ct_1.id,
      :warehouse_id => @wrh_1.id,
      :adjustment_date => nil,
      :description => @description_1
      )
    sa.errors.size.should_not == 0
    sa.should_not be_valid
  end
  
  context "Create Stock Adjustment" do
    before(:each) do
      @sa = CustomerStockAdjustment.create_object(
        :contact_id => @ct_1.id,
        :warehouse_id => @wrh_1.id,
        :adjustment_date => @adjustment_date_1,
        :description => @description_1
        )
    end
    
    it "should create CustomerStockAdjustment" do
      @sa.errors.size.should == 0
      @sa.should be_valid
    end
    
    it "should update CustomerStockAdjustment" do
      @sa.update_object(
        :contact_id => @ct_2.id,
        :warehouse_id => @wrh_2.id,
        :adjustment_date => @adjustment_date_2,
        :description => @description_2
      )
      @sa.warehouse_id.should == @wrh_2.id
      @sa.adjustment_date.should == @adjustment_date_2
      @sa.description.should == @description_2
    end
    
    it "should not update CustomerStockAdjustment if warehouse_id is not valid" do
      @sa.update_object(
        :contact_id => @ct_2.id,
        :warehouse_id => 12312,
        :adjustment_date => @adjustment_date_2,
        :description => @description_2
      )
      @sa.errors.size.should_not == 0
      @sa.should_not be_valid
    end
    
    it "should not update CustomerStockAdjustment if adjustment_date is not valid" do
      @sa.update_object(
        :contact_id => @ct_2.id,
        :warehouse_id => @wrh_2.id,
        :adjustment_date => nil,
        :description => @description_2
      )
      @sa.errors.size.should_not == 0
      @sa.should_not be_valid
    end
    
    it "should delete CustomerStockAdjustment" do
      @sa.delete_object
      @sa.errors.size.should == 0
    end
    
    context "Create CustomerStockAdjustmentDetail" do
      before(:each) do
      @sad_1 = CustomerStockAdjustmentDetail.create_object(
        :customer_stock_adjustment_id => @sa.id,
        :item_id => @item_1.id,
        :price => BigDecimal("5000"),
        :amount => BigDecimal("10"),
        :status => ADJUSTMENT_STATUS[:addition]
        )
      end
      
      it "should create CustomerStockAdjustmentDetail" do
        @sad_1.errors.size.should == 0
        @sad_1.should be_valid
      end
      
      it "should not update CustomerStockAdjustment if have details" do
        @sa.update_object(
          :warehouse_id => @wrh_1.id,
          :adjustment_date => @adjustment_date_2,
          :description => @description_2
        )
        @sa.errors.size.should_not == 0
      end

      it "should not delete CustomerStockAdjustment if have details" do
        @sa.delete_object
        @sa.errors.size.should_not == 0
      end
      
      context "Confirm CustomerStockAdjustment" do
        before(:each) do
          @sa.confirm_object(:confirmed_at => DateTime.now)
          @item_1.reload
        end
        
        it "should confirm CustomerStockAdjustment" do
          @sa.is_confirmed.should be true
        end
        
        it "should create 1 warehouseitem" do
          wh_item = WarehouseItem.where(:warehouse_id => @sa.warehouse_id,:item_id => @sad_1.item_id)
          wh_item.count.should == 1
          wh_item.first.customer_amount.should == @sad_1.amount
        end
        
        it "should add item customer_amount to 10" do
          @item_1.customer_amount.should == @sad_1.amount
        end
        
        it "should set item customer_avg_price to 5000" do
          @item_1.customer_avg_price.should == 5000
        end
        
        it "should create 1 stockmutation" do
          sm = CustomerStockMutation.where(:source_id => @sa.id,:source_class => @sa.class.to_s)
          sm.count.should == 1
        end
        
        it "should not double confirm" do
          @sa.confirm_object(:confirmed_at => DateTime.now)
          @sa.errors.size.should_not == 0
        end
        
        context "Unconfirm CustomerStockAdjustment" do
          before(:each) do
            @sa.unconfirm_object
            @item_1.reload
          end
          
          it "should unconfirm CustomerStockAdjustment" do
            @sa.is_confirmed.should be false
            @sa.confirmed_at.should == nil
            @sa.errors.size.should == 0
          end
          
          it "should change WarehouseItem amount and customer_amount to zero" do
            wh_item = WarehouseItem.where(:warehouse_id => @sa.warehouse_id,:item_id => @sad_1.item_id)
            wh_item.first.amount.should == 0
            wh_item.first.customer_amount.should == 0
          end
          
          it "should change Item amount to zero" do
            @item_1.amount.should == 0
          end
          
          it "should set item customer_avg_price to 0" do
            @item_1.customer_avg_price.should == 0
          end
          
          it "should delete CustomerStockMutation" do
            sm = CustomerStockMutation.where(:source_id => @sa.id,:source_class => @sa.class.to_s)
            sm.count.should == 0
          end
          
          it "should not unconfirm again" do
            @sa.unconfirm_object
            @sa.errors.size.should_not == 0
          end
        end
      end
      
    end
  end
end
