require 'spec_helper'

describe Item do
  before (:each) do
    @name_1 = "Item_1"
    @name_2 = "Item_2"
    @sku_1 = "sku_1"
    @sku_2 = "sku_2"
    @description_1 = "description_1"
    @description_2 = "description_2"
    @is_tradeable_1 = true
    @is_tradeable_2 = false
    @amount_1 = BigDecimal("100")
    @amount_2 = BigDecimal("200")
    @minimum_amount_1 = BigDecimal("50")
    @minimum_amount_2 = BigDecimal("20")
    @selling_price_1 = BigDecimal("10000")
    @selling_price_2 = BigDecimal("20000")
    @price_list_1  =  BigDecimal("5000")
    @price_list_2 = BigDecimal("2500")
    
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
  end
  
  it "should be allowed to create item" do
    item = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => @sku_1,
      :name => @name_1,
      :description => @description_1,
      :is_tradeable => @is_tradeable_1,
      :uom_id => @uom_1.id,
      :minimum_amount => @minimum_amount_1,
      :selling_price => @selling_price_1,
      :exchange_id => @exc_1.id,
      :price_list => @price_list_1
    )
    
    item.should be_valid
    item.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    item = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => @sku_1,
      :name => nil,
      :description => @description_1,
      :is_tradeable => @is_tradeable_1,
      :uom_id => @uom_1.id,
      :minimum_amount => @minimum_amount_1,
      :selling_price => @selling_price_1,
      :exchange_id => @exc_1.id,
      :price_list => @price_list_1
      )
    
    item.errors.size.should_not == 0 
    item.should_not be_valid
    
  end
  
  it "should not create object if name present, but length == 0 " do
    item = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => @sku_1,
      :name => "",
      :description => @description_1,
      :is_tradeable => @is_tradeable_1,
      :uom_id => @uom_1.id,
      :minimum_amount => @minimum_amount_1,
      :selling_price => @selling_price_1,
      :exchange_id => @exc_1.id,
      :price_list => @price_list_1
    )
    
    item.errors.size.should_not == 0 
    item.should_not be_valid
    
  end
  
  it "should not create object if item_type_id not valid" do
    item = Item.create_object(
      :item_type_id => 2313,
      :sub_type_id => @sbp_1.id,
      :sku => @sku_1,
      :name => @name_1,
      :description => @description_1,
      :is_tradeable => @is_tradeable_1,
      :uom_id => @uom_1.id,
      :minimum_amount => @minimum_amount_1,
      :selling_price => @selling_price_1,
      :exchange_id => @exc_1.id,
      :price_list => @price_list_1
      )
    
    item.errors.size.should_not == 0 
    item.should_not be_valid
    
  end
  
  it "should not create object if uom_id not valid" do
    item = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => @sku_1,
      :name => @name_1,
      :description => @description_1,
      :is_tradeable => @is_tradeable_1,
      :uom_id => 2131,
      :minimum_amount => @minimum_amount_1,
      :selling_price => @selling_price_1,
      :exchange_id => @exc_1.id,
      :price_list => @price_list_1
      )
    
    item.errors.size.should_not == 0 
    item.should_not be_valid
    
  end
  
  it "should not create object if exchange_id not valid" do
    item = Item.create_object(
      :item_type_id => @itp_1.id,
      :sub_type_id => @sbp_1.id,
      :sku => @sku_1,
      :name => @name_1,
      :description => @description_1,
      :is_tradeable => @is_tradeable_1,
      :uom_id => @uom_1.id,
      :minimum_amount => @minimum_amount_1,
      :selling_price => @selling_price_1,
      :exchange_id => 23131,
      :price_list => @price_list_1
      )
    
    item.errors.size.should_not == 0 
    item.should_not be_valid
    
  end
  
  context "Create New Item" do
    before (:each) do
      @item = Item.create_object(
        :item_type_id => @itp_1.id,
        :sub_type_id => @sbp_1.id,
        :sku => @sku_1,
        :name => @name_1,
        :description => @description_1,
        :is_tradeable => @is_tradeable_1,
        :uom_id => @uom_1.id,
        :minimum_amount => @minimum_amount_1,
        :selling_price => @selling_price_1,
        :exchange_id => @exc_1.id,
        :price_list => @price_list_1
      )
    end
    
    it "should create item" do
      @item.errors.size.should == 0
      @item.should be_valid
    end
    
    it "should update object" do
      @item.update_object(
        :item_type_id => @itp_2.id,
        :sub_type_id => @sbp_2.id,
        :sku => @sku_2,
        :name => @name_2,
        :description => @description_2,
        :is_tradeable => @is_tradeable_2,
        :uom_id => @uom_2.id,
        :minimum_amount => @minimum_amount_2,
        :selling_price => @selling_price_2,
        :exchange_id => @exc_2.id,
        :price_list => @price_list_2
      )
      @item.errors.size.should == 0
      @item.item_type_id.should == @itp_2.id
      @item.sub_type_id.should == @sbp_2.id
      @item.sku.should == @sku_2
      @item.name.should == @name_2
      @item.description.should == @description_2
      @item.is_tradeable.should == @is_tradeable_2
      @item.uom_id.should == @uom_2.id
      @item.minimum_amount.should == @minimum_amount_2
      @item.selling_price.should == @selling_price_2
      @item.exchange_id.should == @exc_2.id
      @item.price_list.should == @price_list_2
    end
    
    it "cannot update object if name not valid" do
      @item.update_object(
        :item_type_id => @itp_2.id,
        :sub_type_id => @sbp_2.id,
        :sku => @sku_2,
        :name => nil,
        :description => @description_2,
        :is_tradeable => @is_tradeable_2,
        :uom_id => @uom_2.id,
        :minimum_amount => @minimum_amount_2,
        :selling_price => @selling_price_2,
        :exchange_id => @exc_2.id,
        :price_list => @price_list_2
      )
      @item.errors.size.should_not == 0 
      @item.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
      @item.update_object(
        :item_type_id => @itp_2.id,
        :sub_type_id => @sbp_2.id,
        :sku => @sku_2,
        :name => "",
        :description => @description_2,
        :is_tradeable => @is_tradeable_2,
        :uom_id => @uom_2.id,
        :minimum_amount => @minimum_amount_2,
        :selling_price => @selling_price_2,
        :exchange_id => @exc_2.id,
        :price_list => @price_list_2
      )
      @item.errors.size.should_not == 0 
      @item.should_not be_valid
    end   
    
    it "cannot update object if item_type_id not valid" do
      @item.update_object(
        :item_type_id => 12312,
        :sub_type_id => @sbp_2.id,
        :sku => @sku_2,
        :name => @name_2,
        :description => @description_2,
        :is_tradeable => @is_tradeable_2,
        :uom_id => @uom_2.id,
        :minimum_amount => @minimum_amount_2,
        :selling_price => @selling_price_2,
        :exchange_id => @exc_2.id,
        :price_list => @price_list_2
      )
      @item.errors.size.should_not == 0 
      @item.should_not be_valid
    end  
    
    it "cannot update object if uom_id not valid" do
      @item.update_object(
        :item_type_id => @itp_2.id,
        :sub_type_id => @sbp_2.id,
        :sku => @sku_2,
        :name => @name_2,
        :description => @description_2,
        :is_tradeable => @is_tradeable_2,
        :uom_id => 123123,
        :minimum_amount => @minimum_amount_2,
        :selling_price => @selling_price_2,
        :exchange_id => @exc_2.id,
        :price_list => @price_list_2
      )
      @item.errors.size.should_not == 0 
      @item.should_not be_valid
    end  
    
    it "cannot update object if exchange_id not valid" do
      @item.update_object(
        :item_type_id => @itp_2.id,
        :sub_type_id => @sbp_2.id,
        :sku => @sku_2,
        :name => @name_2,
        :description => @description_2,
        :is_tradeable => @is_tradeable_2,
        :uom_id => @uom_2.id,
        :minimum_amount => @minimum_amount_2,
        :selling_price => @selling_price_2,
        :exchange_id => 123123,
        :price_list => @price_list_2
      )
      @item.errors.size.should_not == 0 
      @item.should_not be_valid
    end  
  
    it "should delete object" do
      @item.delete_object
      Item.count.should == 0
    end
  end
  
end
