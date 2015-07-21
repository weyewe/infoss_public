require 'spec_helper'

describe BlendingWorkOrder do
  before(:each) do
    
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
    
    @itp_2 = ItemType.create_object(
      :name => "ItemType_2" ,
      :description => "Description1",
      :account_id => @coa_1.id
      )
    
    @sbp_1 = SubType.create_object(
      :name => "SubType_1" ,
      :item_type_id => @itp_1.id
      )
    
    @sbp_2 = SubType.create_object(
      :name => "SubType_2" ,
      :item_type_id => @itp_1.id
      )
    
    @uom_1 = Uom.create_object(
      :name => "Uom_1" ,
      )
    
    @uom_2 = Uom.create_object(
      :name => "Uom_2" ,
      )
    
    @exc_1 = Exchange.create_object(
      :name => "IDR1",
      :description => @description_1,
      )
    
    @exc_2 = Exchange.create_object(
      :name => "USD",
      :description => @description_1,
      )
      
    @item_1 = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => "sku_1",
      :name => "name_1",
      :description => "description_1",
      :is_tradeable => true,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("100"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
      )  
      
    @item_2 = Item.create_object(
      :item_type_id => @itp_2.id,
      :sub_type_id => @sbp_2.id,
      :sku => "sku_2",
      :name => "name_2",
      :description => "description_1",
      :is_tradeable => false,
      :uom_id => @uom_1.id,
      :minimum_amount => BigDecimal("1"),
      :selling_price => BigDecimal("150"),
      :price_list => BigDecimal("500"),
      :exchange_id => @exc_1.id,
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
    
    @br = BlendingRecipe.create_object(
      :name => "name_1",
      :description => "description_1",
      :target_item_id => @item_1.id,
      :target_amount => 1
      )
    
    @brd = BlendingRecipeDetail.create_object(
      :blending_recipe_id => @br.id,
      :item_id => @item_2.id,
      :amount => 1
      )
    
    @sa_1 = StockAdjustment.create_object(
      :warehouse_id => @wrh_1.id,
      :adjustment_date => DateTime.now,
      :description => @description_1
      )
     
    @sad_1 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa_1.id,
      :item_id => @item_2.id,
      :price => BigDecimal("1000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
      
    @sa_1.confirm_object(:confirmed_at => DateTime.now)
    
    
    @description_1 = "description_1"
    @description_2 = "description_2"
    @code_1 = "code_1"
    @code_2 = "code_2"
    @blending_date_1 = DateTime.now
    @blending_date_2 = DateTime.now + 1.days
  end
  
  it "should not Create BlendingWorkOrder if blending_recipe_id is not valid" do
    bwo = BlendingWorkOrder.create_object(
      :blending_recipe_id => 123213,
      :warehouse_id => @wrh_1.id,
      :description => @description_1,
      :blending_date => @blending_date_1,
      :code => @code_1
      )
    bwo.errors.size.should_not == 0
    bwo.should_not be_valid
  end
  
  it "should not Create BlendingWorkOrder if warehouse_id is not valid" do
    bwo = BlendingWorkOrder.create_object(
      :blending_recipe_id => @br.id,
      :warehouse_id => 123213,
      :description => @description_1,
      :blending_date => @blending_date_1,
      :code => @code_1
      )
    bwo.errors.size.should_not == 0
    bwo.should_not be_valid
  end
  
  it "should not Create BlendingWorkOrder if blending_date is not valid" do
    bwo = BlendingWorkOrder.create_object(
      :blending_recipe_id => @br.id,
      :warehouse_id => @wrh_1.id,
      :description => @description_1,
      :blending_date => nil,
      :code => @code_1
      )
    bwo.errors.size.should_not == 0
    bwo.should_not be_valid
  end
  
  context "Create BlendingWorkOrder" do
    before(:each) do
      @bwo = BlendingWorkOrder.create_object(
        :blending_recipe_id => @br.id,
        :warehouse_id => @wrh_1.id,
        :description => @description_1,
        :blending_date => @blending_date_1,
        :code => @code_1
        )
    end
    
    it "should create BlendingWorkOrder" do
      @bwo.errors.size.should == 0
      @bwo.should be_valid
    end
    
    it "should not update BlendingWorkOrder if blending_recipe_id is not valid" do
      @bwo.update_object(
        :blending_recipe_id =>123124124,
        :warehouse_id => @wrh_2.id,
        :description => @description_2,
        :blending_date => @blending_date_2,
        :code => @code2
        )
      @bwo.errors.size.should_not == 0
      @bwo.should_not be_valid
    end
    
    it "should not update BlendingWorkOrder if warehouse_id is not valid" do
      @bwo.update_object(
        :blending_recipe_id => @br.id,
        :warehouse_id => 12321321,
        :description => @description_2,
        :blending_date => @blending_date_2,
        :code => @code2
        )
      @bwo.errors.size.should_not == 0
      @bwo.should_not be_valid
    end
    
    it "should not update BlendingWorkOrder if blending_date is not valid" do
      @bwo.update_object(
        :blending_recipe_id => @br.id,
        :warehouse_id => @wrh_2.id,
        :description => @description_2,
        :blending_date => nil,
        :code => @code2
        )
      @bwo.errors.size.should_not == 0
      @bwo.should_not be_valid
    end
    
    it "should update BlendingWorkOrder" do
      @bwo.update_object(
        :blending_recipe_id => @br.id,
        :warehouse_id => @wrh_2.id,
        :description => @description_2,
        :blending_date => @blending_date_2,
        :code => @code2
        )
      @bwo.errors.size.should == 0
      @bwo.blending_recipe_id.should == @br.id
      @bwo.warehouse_id.should == @wrh_2.id
      @bwo.description.should == @description_2
      @bwo.blending_date.should == @blending_date_2
    end
    
    it "should delete BlendingWorkOrder" do
      @bwo.delete_object
      @bwo.errors.size.should == 0
      BlendingWorkOrder.count.should == 0
    end
    
    context "Confirm BlendingWorkOrder" do
      before(:each) do
        @bwo.confirm_object(
          :confirmed_at => DateTime.now
          )
      end
      
      it "should confirm BlendingWorkOrder" do
        @bwo.errors.size.should == 0
        @bwo.is_confirmed.should == true
      end
      
      context "Unconfirm BlendingWorkOrder" do
        before (:each) do 
          @bwo.unconfirm_object
        end
        
        it "should unconfirm BlendingWorkOrder" do
          @bwo.errors.size.should == 0
          @bwo.is_confirmed.should == false
        end
      end
      
    end
    
  end
end
