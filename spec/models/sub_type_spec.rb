require 'spec_helper'

describe SubType do
   before (:each) do
    @name_1 = "sub_type1"
    @name_2 = "sub_type2"
    @description_1 = "description_1"
    @description_2 = "description_2"
    @coa_1 = Account.create_object(
      :code => "1110ko",
      :name => "KAS",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:aktiva][:code]).id
   
      )
    @coa_2 = Account.create_object(
      :code => "1110ko123",
      :name => "BEBAN USAHA",
      :account_case => ACCOUNT_CASE[:ledger],
      :parent_id => Account.find_by_code(ACCOUNT_CODE[:beban_usaha][:code]).id
   
      )
    @itp_1 = ItemType.create_object(
      :name => "ItemType1" ,
      :description => @description_1,
      :account_id => @coa_1.id
      )
    @itp_2 = ItemType.create_object(
      :name => "ItemType2" ,
      :description => @description_2,
      :account_id => @coa_2.id
      )
     
  end
  
  it "should be allowed to create sub_type" do
    sbp = SubType.create_object(
      :name => @name_1,
      :item_type_id => @itp_1.id
    )
    
    sbp.should be_valid
    sbp.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    sbp = SubType.create_object(
      :name => nil ,
      :item_type_id => @itp_1.id
      )
    
    sbp.errors.size.should_not == 0 
    sbp.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    sbp = SubType.create_object(
      :name => "" ,
      :item_type_id => @itp_1.id
    )
    
    sbp.errors.size.should_not == 0 
    sbp.should_not be_valid
    
  end
  
  it "should create object if item_type_id is not valid " do
    sbp = SubType.create_object(
      :name => @name_1 ,
      :item_type_id => 12312342
    )
    
    sbp.errors.size.should_not == 0 
    sbp.should_not be_valid
    
  end
  context "Create New ItemType" do
    before (:each) do
      @sbp = SubType.create_object(
        :name => @name_1 ,
        :item_type_id => @itp_1.id
      )
    end
    
    it "should create sub_type" do
      @sbp.errors.size.should == 0
      @sbp.should be_valid
    end
    
    it "cannot update object if name not valid" do
     @sbp.update_object(
        :name => nil,
       :item_type_id => @itp_1.id
     )
     @sbp.errors.size.should_not == 0 
     @sbp.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @sbp.update_object(
       :name => "",
       :item_type_id => @itp_1.id
     )
     @sbp.errors.size.should_not == 0 
     @sbp.should_not be_valid
    end   
    
    it "cannot update object if item_type_id not valid" do
     @sbp.update_object(
       :name => @name_1,
       :item_type_id => 1231
     )
     @sbp.errors.size.should_not == 0 
     @sbp.should_not be_valid
    end
    
    it "should update object" do
      @sbp.update_object(
       :name => @name_2 ,
      :item_type_id => @itp_2.id
      )
      @sbp.name.should == @name_2
      @sbp.item_type_id.should == @itp_2.id
    end
  
    it "should delete object" do
      @sbp.delete_object
      SubType.count.should == 0
    end
  end
end
