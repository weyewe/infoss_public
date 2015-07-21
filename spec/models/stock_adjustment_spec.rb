require 'spec_helper'

describe StockAdjustment do
  
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

  it "should create StockAdjustment" do
    sa = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => @adjustment_date_1,
      :description => @description_1
      )
    sa.errors.size.should == 0
    sa.should be_valid
  end
  
  it "should not create StockAdjustment if warehouse is not valid" do
    sa = StockAdjustment.create_object(
      :warehouse_id => 5123,
      :adjustment_date => @adjustment_date_1,
      :description => @description_1
      )
    sa.errors.size.should_not == 0
    sa.should_not be_valid
  end
  
  it "should not create StockAdjustment if adjustment_date is not valid" do
    sa = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => nil,
      :description => @description_1
      )
    sa.errors.size.should_not == 0
    sa.should_not be_valid
  end
  
  context "Create Stock Adjustment" do
    before(:each) do
      @sa = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => @adjustment_date_1,
      :description => @description_1
      )
    end
    
    it "should create StockAdjustment" do
      @sa.errors.size.should == 0
      @sa.should be_valid
    end
    
    it "should update StockAdjustment" do
      @sa.update_object(
        :warehouse_id => @wrh_2.id,
        :adjustment_date => @adjustment_date_2,
        :description => @description_2
      )
      @sa.warehouse_id.should == @wrh_2.id
      @sa.adjustment_date.should == @adjustment_date_2
      @sa.description.should == @description_2
    end
    
    it "should not update StockAdjustment if warehouse_id is not valid" do
      @sa.update_object(
        :warehouse_id => 12312,
        :adjustment_date => @adjustment_date_2,
        :description => @description_2
      )
      @sa.errors.size.should_not == 0
      @sa.should_not be_valid
    end
    
    it "should not update StockAdjustment if adjustment_date is not valid" do
      @sa.update_object(
        :warehouse_id => @wrh_2.id,
        :adjustment_date => nil,
        :description => @description_2
      )
      @sa.errors.size.should_not == 0
      @sa.should_not be_valid
    end
    
    it "should delete StockAdjustment" do
      @sa.delete_object
      @sa.errors.size.should == 0
    end
    
    context "Create StockAdjusmentDetail" do
      before(:each) do
      @sad_1 = StockAdjustmentDetail.create_object(
        :stock_adjustment_id => @sa.id,
        :item_id => @item_1.id,
        :price => BigDecimal("5000"),
        :amount => BigDecimal("10"),
        :status => ADJUSTMENT_STATUS[:addition]
        )
      end
      
      it "should create StockAdjustmentDetail" do
        @sad_1.errors.size.should == 0
        @sad_1.should be_valid
      end
      
      it "should not update StockAdjustment if have details" do
        @sa.update_object(
          :warehouse_id => @wrh_1.id,
          :adjustment_date => @adjustment_date_2,
          :description => @description_2
        )
        @sa.errors.size.should_not == 0
      end

      it "should not delete StockAdjustment if have details" do
        @sa.delete_object
        @sa.errors.size.should_not == 0
      end
      
      context "Confirm StockAdjusment" do
        before(:each) do
          @sa.confirm_object(:confirmed_at => DateTime.now)
          @item_1.reload
        end
        
        it "should confirm StockAdjusment" do
          @sa.is_confirmed.should be true
        end
        
        it "should create 1 warehouseitem" do
          wh_item = WarehouseItem.where(:warehouse_id => @sa.warehouse_id,:item_id => @sad_1.item_id)
          wh_item.count.should == 1
          wh_item.first.amount.should == @sad_1.amount
        end
        
        it "should add item amount to 10" do
          @item_1.amount.should == @sad_1.amount
        end
        
        it "should set item avg_price to 5000" do
          @item_1.avg_price.should == 5000
        end
        
        it "should create 1 stockmutation" do
          sm = StockMutation.where(:source_id => @sa.id,:source_class => @sa.class.to_s)
          sm.count.should == 1
        end
        
        it "should not double confirm" do
          @sa.confirm_object(:confirmed_at => DateTime.now)
          @sa.errors.size.should_not == 0
        end
        
        context "Unconfirm StockAdjustment" do
          before(:each) do
            @sa.unconfirm_object
            @item_1.reload
          end
          
          it "should unconfirm StockAdjustment" do
            @sa.is_confirmed.should be false
            @sa.confirmed_at.should == nil
            @sa.errors.size.should == 0
          end
          
          it "should change WarehouseItem amount to zero" do
            wh_item = WarehouseItem.where(:warehouse_id => @sa.warehouse_id,:item_id => @sad_1.item_id)
            wh_item.first.amount.should == 0
          end
          
          it "should change Item amount to zero" do
            @item_1.amount.should == 0
          end
          
          it "should set item avg_price to 0" do
            @item_1.avg_price.should == 0
          end
          
          it "should delete StockMutation" do
            sm = StockMutation.where(:source_id => @sa.id,:source_class => @sa.class.to_s)
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
