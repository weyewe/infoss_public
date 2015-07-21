require 'spec_helper'

describe WarehouseMutation do
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
    
    @mutation_date_1 = DateTime.now
    @mutation_date_2 = DateTime.now + 1.days
    @description_1 = "Description1"
    @description_2 = "Description2"
     
    @sa_1 = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => DateTime.now,
      :description => @description_1
      )
     
    @sad_1 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @item_1.id,
      :price => BigDecimal("5000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
    
    @sa_1.confirm_object(:confirmed_at => DateTime.now)
  end
 
  it "should not create WarehouseMutation if warehouse_from is not valid" do
    wm = WarehouseMutation.create_object(
      :warehouse_from_id => 12213,
      :warehouse_to_id => @wrh_2.id,
      :mutation_date => @mutation_date_1,
      )
    wm.errors.size.should_not == 0
    wm.should_not be_valid
  end
  
  it "should not create WarehouseMutation if warehouse_to is not valid" do
    wm = WarehouseMutation.create_object(
      :warehouse_from_id => @wrh_1.id,
      :warehouse_to_id => 123123,
      :mutation_date => @mutation_date_1,
      )
    wm.errors.size.should_not == 0
    wm.should_not be_valid
  end
  
  it "should not create WarehouseMutation if mutation_date is not valid" do
    wm = WarehouseMutation.create_object(
      :warehouse_from_id => @wrh_1.id,
      :warehouse_to_id => @wrh_2.id,
      :mutation_date => nil,
      )
    wm.errors.size.should_not == 0
    wm.should_not be_valid
  end
  
  context "Create WarehouseMutation" do
    before(:each) do
      @wm = WarehouseMutation.create_object(
      :warehouse_from_id => @wrh_1.id,
      :warehouse_to_id => @wrh_2.id,
      :mutation_date => @mutation_date_1,
      )
    end
    
    it "should create WarehouseMutation" do
      @wm.errors.size.should == 0
      @wm.should be_valid
    end
    
    it "should update WarehouseMutation" do
      @wm.update_object(
        :warehouse_from_id => @wrh_2.id,
        :warehouse_to_id => @wrh_1.id,
        :mutation_date => @mutation_date_2,
        )
      @wm.warehouse_from_id.should == @wrh_2.id
      @wm.warehouse_to_id.should == @wrh_1.id
      @wm.mutation_date.should == @mutation_date_2
    end
    
    it "should not update WarehouseMutation if warehouse_from_id is not valid" do
      @wm.update_object(
        :warehouse_from_id => 123123,
        :warehouse_to_id => @wrh_1.id,
        :mutation_date => @mutation_date_2,
      )
      @wm.errors.size.should_not == 0
      @wm.should_not be_valid
    end
    
    it "should not update WarehouseMutation if warehouse_to_id is not valid" do
      @wm.update_object(
        :warehouse_from_id => @wrh_2.id,
        :warehouse_to_id => 123123,
        :mutation_date => @mutation_date_2,
      )
      @wm.errors.size.should_not == 0
      @wm.should_not be_valid
    end
    
    it "should not update WarehouseMutation if mutation_date is not valid" do
      @wm.update_object(
        :warehouse_from_id => @wrh_2.id,
        :warehouse_to_id => @wrh_1.id,
        :mutation_date => nil,
      )
      @wm.errors.size.should_not == 0
      @wm.should_not be_valid
    end
    
    it "should delete WarehouseMutation" do
      @wm.delete_object
      @wm.errors.size.should == 0
    end
    
    context "Create WarehouseMutationDetail" do
      before(:each) do
      @wmd_1 = WarehouseMutationDetail.create_object(
        :warehouse_mutation_id => @wm.id,
        :item_id => @item_1.id,
        :amount => BigDecimal("10"),
        )
      end
      
      it "should create WarehouseMutationDetail" do
        @wmd_1.errors.size.should == 0
        @wmd_1.should be_valid
      end
      
      it "should not update WarehouseMutation if have details" do
        @wm.update_object(
          :warehouse_from_id => @wrh_2.id,
          :warehouse_to_id => @wrh_1.id,
          :mutation_date => @mutation_date_2,
        )
        @wm.errors.size.should_not == 0
      end

      it "should not delete WarehouseMutation if have details" do
        @wm.delete_object
        @wm.errors.size.should_not == 0
      end
      
      context "Confirm WarehouseMutation" do
        before(:each) do
          @wm.confirm_object(:confirmed_at => DateTime.now)
        end
        
        it "should confirm WarehouseMutation" do
          @wm.is_confirmed.should be true
        end
        
        it "should change WarehouseItemfrom amount to 0" do
          wh_item = WarehouseItem.where(:warehouse_id => @wm.warehouse_from_id,:item_id => @wmd_1.item_id)
          wh_item.first.amount.should == 0
        end

        it "should change WarehouseItemTo amount to 10" do
          wh_item = WarehouseItem.where(:warehouse_id => @wm.warehouse_to_id,:item_id => @wmd_1.item_id)
          wh_item.first.amount.should == 10
        end
        
        it "should create 2 stockmutation" do
          sm = StockMutation.where(:source_id => @wm.id,:source_class => @wm.class.to_s)
          sm.count.should == 2
        end
        
        it "should not double confirm" do
          @wm.confirm_object(:confirmed_at => DateTime.now)
          @wm.errors.size.should_not == 0
        end
        
        context "Unconfirm WarehouseMutation" do
          before(:each) do
            @wm.unconfirm_object
          end
          
          it "should unconfirm WarehouseMutation" do
            @wm.is_confirmed.should be false
            @wm.confirmed_at.should == nil
            @wm.errors.size.should == 0
          end
          
          it "should change WarehouseItemfrom amount to 10" do
            wh_item = WarehouseItem.where(:warehouse_id => @wm.warehouse_from_id,:item_id => @wmd_1.item_id)
            wh_item.first.amount.should == 10
          end
          
          it "should change WarehouseItemTo amount to zero" do
            wh_item = WarehouseItem.where(:warehouse_id => @wm.warehouse_to_id,:item_id => @wmd_1.item_id)
            wh_item.first.amount.should == 0
          end
          
          it "should delete StockMutation" do
            sm = StockMutation.where(:source_id => @wm.id,:source_class => @wm.class.to_s)
            sm.count.should == 0
          end
          
          it "should not unconfirm again" do
            @wm.unconfirm_object
            @wm.errors.size.should_not == 0
          end
        end
      end
      
    end
  end
end
