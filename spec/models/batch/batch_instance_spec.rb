require 'spec_helper'

describe BatchInstance do
  
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
  
    @sa = StockAdjustment.create_object(
    :warehouse_id => @wrh_1.id,
    :adjustment_date => @adjustment_date_1,
    :description => @description_1
    )
    @sad_1 = StockAdjustmentDetail.create_object(
      :stock_adjustment_id => @sa.id,
      :item_id => @item_1.id,
      :price => BigDecimal("5000"),
      :amount => BigDecimal("10"),
      :status => ADJUSTMENT_STATUS[:addition]
      )
    @sa.confirm_object(:confirmed_at => DateTime.now)
    @item_1.reload
  end
  
  it "should be allowed to create BatchInstance" do

        
    ep = BatchInstance.create_object(
        :item_id         => @item_1.id , 
        :name            => "The name ", 
        :description     => "The description" ,   
        :manufactured_at => DateTime.now 
    )
    
    ep.should be_valid
    ep.errors.size.should == 0 
  end
  
  it "should not create BatchInstance without name" do
    ep = BatchInstance.create_object(
         :item_id         => @item_1.id , 
        :name            =>  nil , 
        :description     => "The description" ,   
        :manufactured_at => DateTime.now 
      )
    
    ep.errors.size.should_not == 0 
    ep.should_not be_valid
    
  end
  
  it "should not create BatchInstance if name present, but length == 0 " do
    ep = BatchInstance.create_object(
        :item_id         => @item_1.id , 
        :name            => "", 
        :description     => "The description" ,   
        :manufactured_at => DateTime.now 
    )
    
    ep.errors.size.should_not == 0 
    ep.should_not be_valid
    
  end
  
  
  context "Create New BatchInstance" do
    before (:each) do
      @ep = BatchInstance.create_object(
        :item_id         => @item_1.id , 
        :name            => "The name ", 
        :description     => "The description" ,   
        :manufactured_at => DateTime.now 
        )
    end
    
    it "should create BatchInstance" do
      @ep.errors.size.should == 0
      @ep.should be_valid
    end
    
    it "cannot update object if name not valid" do
      @ep.update_object(
        :item_id         => @item_1.id , 
        :name            => nil , 
        :description     => "The description" ,   
        :manufactured_at => DateTime.now 
     )
     @ep.errors.size.should_not == 0 
     @ep.should_not be_valid
    end
    
    it "cannot update object if name present, but length == 0" do
      @ep.update_object(
        :item_id         => @item_1.id , 
        :name            => "", 
        :description     => "The description" ,   
        :manufactured_at => DateTime.now 
        )
      @ep.errors.size.should_not == 0 
      @ep.should_not be_valid
    end   
    
    it "should update object" do
      @ep.update_object(
        :item_id         => @item_1.id , 
        :name            => "The name aefafea ", 
        :description     => "The description" ,   
        :manufactured_at => DateTime.now 
      )
      @ep.errors.size.should == 0 
    end
  
    it "should delete object" do
      @ep.delete_object
      BatchInstance.count.should == 0
    end
  end
end
