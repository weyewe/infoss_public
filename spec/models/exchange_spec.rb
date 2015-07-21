require 'spec_helper'

describe Exchange do
  before(:each) do
   @name_1 = "IDR1"
   @name_2 = "USD"
   @description_1 = "Description 1"
   @description_2 = "Description 2"
  end
  
  it "should be allowed to create Exchange" do
    exc = Exchange.create_object(
      :name => @name_1,
      :description => @description_1
      )
    exc.should be_valid
    exc.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    exc = Exchange.create_object(
      :name => nil ,
      :description => @description_1,            
      )
    exc.errors.size.should_not == 0 
    exc.should_not be_valid
  end
  
  it "should create object if name present, but length == 0 " do
    exc = Exchange.create_object(
      :name => "" ,
      :description => @description_1,
      )
    exc.errors.size.should_not == 0 
    exc.should_not be_valid
  end
  
  context "create Exchange" do
    before(:each) do 
      @exc_1 = Exchange.create_object(
        :name => @name_1,
        :description => @description_1,
      )
    end
  
     it "should update gbch_ar_ap_id  " do
        @exc_1.account_payable_id.should_not == nil
        @exc_1.account_receivable_id.should_not == nil
        @exc_1.gbch_payable_id.should_not == nil
        @exc_1.gbch_receivable_id.should_not == nil
      end
      
    it "should update exchange" do
      @exc_1.update_object(
        :name => @name_2,
        :description => @description_2,
      )
      @exc_1.errors.size.should == 0
      @exc_1.name.should == @name_2
      @exc_1.description.should == @description_2
      
    end
    
    it "should delete exchange" do
      @exc_1.delete_object
      ExchangeRate.count.should == 0
    end
    
    it "should not be allowed to create another exc with same name" do
      @exc_2 = Exchange.create_object(
        :name => @name_1,
        :description => @description_2,
        
      )
      @exc_2.errors.size.should_not == 0 
      @exc_2.should_not be_valid
    end
    
    context "Create new Exchange" do
      before(:each) do
        @exc_2 = Exchange.create_object(
          :name => @name_2,
          :description => @description_2,
        )
      end
      
      it "should have valid exc2 and valid exc1" do
        @exc_2.should be_valid
        @exc_1.should be_valid
      end
      
      it "should not allow update with duplicate name" do
        @exc_2.update_object(
            :name => @name_1,
            :description => "ehaufeahifi heaw",
        )
        @exc_2.errors.size.should_not == 0 
      end
      
    end
    
    context "Create Base Exchange" do
      before(:each) do
        @base_exc = Exchange.create_object_for_base_exchange
      end
      
      it "should not update if is_base is true" do
       @base_exc.update_object(
         :name => "BaseCurrency",
         :description => "Description",
        )
        @base_exc.errors.size.should_not == 0 
      end
      
     
      it "should not delete if is_base is true" do
        @base_exc.delete_object
        @base_exc.errors.size.should_not == 0
      end
      
    end
    
  end
end
