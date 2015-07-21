require 'spec_helper'

describe BlendingRecipe do
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
    @name_1 = "name_1"
    @name_2 = "name_2"
    @description_1 = "description_1"
    @description_2 = "description_2"
    @target_amount_1 = BigDecimal("10")
    @target_amount_2 = BigDecimal("15")
    @amount_1 = BigDecimal("10")
  end
  
  it "should not create BlendingRecipe if name is not valid" do
    br = BlendingRecipe.create_object(
      :name => nil,
      :description => @description_1,
      :target_item_id => @item_1.id,
      :target_amount => @target_amount_1
      )
    br.errors.size.should_not == 0
  end
  
  it "should not create BlendingRecipe if target_item_id is not valid" do
    br = BlendingRecipe.create_object(
      :name => @name_1,
      :description => @description_1,
      :target_item_id => 12333,
      :target_amount => @target_amount_1
      )
    br.errors.size.should_not == 0
  end
  
  context "Create BlendingRecipe" do
    before(:each) do
      @br = BlendingRecipe.create_object(
        :name => @name_1,
        :description => @description_1,
        :target_item_id => @item_1.id,
        :target_amount => @target_amount_1
        )
    end
    
    it "should create BlendingRecipe" do
      @br.errors.size.should == 0
      @br.should be_valid
    end
    
    it "should not update BlendingRecipe if name is not valid" do
      @br.update_object(
        :name => nil,
        :description => @description_1,
        :target_item_id => @item_1.id,
        :target_amount => @target_amount_1
        )
      @br.errors.size.should_not == 0
      @br.should_not be_valid 
    end
    
    it "should not update BlendingRecipe if target_item_id is not valid" do
      @br.update_object(
        :name => @name_1,
        :description => @description_1,
        :target_item_id => 123123,
        :target_amount => @target_amount_1
        )
      @br.errors.size.should_not == 0
      @br.should_not be_valid
    end
    
    it "should update BlendingRecipe" do
      @br.update_object(
        :name => @name_2,
        :description => @description_2,
        :target_item_id => @item_2.id,
        :target_amount => @target_amount_2
        )
      @br.errors.size.should == 0
      @br.should be_valid
    end
    
    it "should delete BlendingRecipe" do
      @br.delete_object
      BlendingRecipe.count.should == 0
      
    end
    
    context "Create BlendingRecipeDetail" do
      before(:each) do
        @brd = BlendingRecipeDetail.create_object(
          :blending_recipe_id => @br.id,
          :item_id => @item_2.id,
          :amount => @amount_1
          )
      end
        
      it "should create BlendingRecipeDetail" do
        @brd.errors.size.should == 0
        @brd.should be_valid
      end
      
      it "should not delete BlendingRecipe if have detail" do
        @br.delete_object
        @br.errors.size.should_not == 0
      end
    end
  end
  
end
