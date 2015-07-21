require 'spec_helper'

describe CashBank do
  
  before(:each) do
    @name_1 = "BCA"
    @name_2 = "BNI"
    @description_1 = "Description 1"
    @description_2 = "Description 2" 
    @exc_1 = Exchange.create_object(
        :name => "@name_1",
        :description => "@description_1",
    )
    @exc_2 = Exchange.create_object(
        :name => "@name_21",
        :description => "@description_1",
    )
  end
  
  it "should be allowed to create CashBank" do
    cb = CashBank.create_object(
      :name => @name_1,
      :description => @description_1,
      :is_bank => true,
      :exchange_id => @exc_1.id
    )
    cb.should be_valid
    cb.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    cb = CashBank.create_object(
      :name => nil ,
      :description => @description_1,
      :is_bank => true,
      :exchange_id => @exc_1.id
    )
    cb.errors.size.should_not == 0 
    cb.should_not be_valid
  end
  
  it "should create object if name present, but length == 0 " do
    cb = CashBank.create_object(
      :name => "" ,
      :description => @description_1,
      :is_bank => true,
      :exchange_id => @exc_1.id
    )
    cb.errors.size.should_not == 0 
    cb.should_not be_valid
  end
  
  context "create new CashBank"do
    before(:each) do 
      @cb_1 = CashBank.create_object(
        :name => @name_1,
        :description => @description_1,
        :is_bank => true,
        :exchange_id => @exc_1.id
      )
    end
    
    it "should not be allowed to create another cb with same name" do
      @cb_2 = CashBank.create_object(
        :name => @name_1,
        :description => @description_1,
        :is_bank => true,
        :exchange_id => @exc_1.id
      )
      @cb_2.errors.size.should_not == 0 
      @cb_2.should_not be_valid
    end
    
    it "should update CashBank" do
      @cb_1.update_object(
        :name => @name_2,
        :description => @description_2,
        :is_bank => false,
        :exchange_id => @exc_2.id
      )
     
      @cb_1.errors.each do |x|
      puts x
      end
      @cb_1.errors.size.should == 0 
      @cb_1.name.should == @name_2
      @cb_1.description.should == @description_2
      @cb_1.is_bank.should be_false
      @cb_1.exchange_id.should == @exc_2.id
    end
    
    it "should not allow update if name is not valid" do
      @cb_1.update_object(
        :name => nil,
        :description => @description_2,
        :is_bank => false,
        :exchange_id => @exc_2.id
      )
      @cb_1.errors.size.should_not == 0 
    end
    
    it "should not allow update if exchange is not valid" do
      @cb_1.update_object(
        :name => @name_2,
        :description => @description_2,
        :is_bank => false,
        :exchange_id => 12312
      )
      @cb_1.errors.size.should_not == 0 
    end
    
    it "should delete CashBank" do
      @cb_1.delete_object
      CashBank.count.should == 0
    end
    
    context "can't update object that will dis validate the uniqueness contraint" do
      before(:each) do
        @cb_2 = CashBank.create_object(
          :name => @name_2,
          :description => @description_2,
          :is_bank => true,
          :exchange_id => @exc_1.id
        )
      end
      
      it "should have valid cb2 and valid cb1" do
        @cb_2.should be_valid
        @cb_1.should be_valid
      end
      
      it "should not allow update with duplicate name" do
        @cb_2.update_object(
            :name => @name_1,
            :description => "ehaufeahifi heaw",
            :is_bank => true,
            :exchange_id => @exc_1.id
          )
        @cb_2.errors.size.should_not == 0 
      end
    end
  end
end
