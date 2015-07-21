require 'spec_helper'

describe ItemType do
  before (:each) do
    @name_1 = "item_type1"
    @name_2 = "item_type2"
    @description_1 = "description_1"
    @description_2 = "description_2"
    @coa_1 = Account.create_object(
        :code => "1110101",
        :name => "KAS",
        :group => ACCOUNT_GROUP[:asset],
        :level => 1
      )
    @coa_2 = Account.create_object(
        :code => "111102",
        :name => "BANK",
        :group => ACCOUNT_GROUP[:expense],
        :level => 2
      )
  end
  
  it "should be allowed to create item_type" do
    itp = ItemType.create_object(
      :name => @name_1,
      :description => @description_1,
      :account_id => @coa_1.id
    )
    
    itp.should be_valid
    itp.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    itp = ItemType.create_object(
      :name => nil ,
      :description => @description_1,
      :account_id => @coa_1.id
      )
    
    itp.errors.size.should_not == 0 
    itp.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    itp = ItemType.create_object(
       :name => "" ,
       :description => @description_1,
      :account_id => @coa_1.id
    )
    
    itp.errors.size.should_not == 0 
    itp.should_not be_valid
    
  end
  
  it "should create object if account_id is not valid " do
    itp = ItemType.create_object(
       :name => @name_1 ,
       :description => @description_1,
       :account_id => 123
    )
    
    itp.errors.size.should_not == 0 
    itp.should_not be_valid
    
  end
  context "Create New ItemType" do
    before (:each) do
      @itp = ItemType.create_object(
        :name => @name_1 ,
        :description => @description_1,
        :account_id => @coa_1.id
      )
    end
    
    it "should create item_type" do
      @itp.errors.size.should == 0
      @itp.should be_valid
    end
    
    it "cannot update object if name not valid" do
     @itp.update_object(
        :name => nil,
        :description => @description_1,
       :account_id => @coa_1.id
     )
     @itp.errors.size.should_not == 0 
     @itp.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @itp.update_object(
       :name => "",
       :description => @description_1,
       :account_id => @coa_1.id
     )
     @itp.errors.size.should_not == 0 
     @itp.should_not be_valid
    end   
    
    it "cannot update object if chart_of_acccount_id not valid" do
     @itp.update_object(
       :name => @name_1,
        :description => @description_1,
       :account_id => 1234
     )
     @itp.errors.size.should_not == 0 
     @itp.should_not be_valid
    end
    
    it "should update object" do
      @itp.update_object(
       :name => @name_2 ,
       :description => @description_2,
        :account_id => @coa_2.id
      )
      @itp.name.should == @name_2
      @itp.description.should == @description_2
      @itp.account_id.should == @coa_2.id
    end
  
    it "should delete object" do
      @itp.delete_object
      @itp.should nil
    end
  end
end
