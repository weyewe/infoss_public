require 'spec_helper'

describe ExchangeRate do
  before(:each) do
   @ex_rate_date_1 = DateTime.now
   @ex_rate_date_2 = DateTime.now + 1.days
   @exc_1 = Exchange.create_object(
      :name => "IDR1",
      :description => "Description"
   )
   @exc_2 = Exchange.create_object(
      :name => "USD",
      :description => "Description"
   )
    @rate_1 = BigDecimal("10000")
    @rate_2 = BigDecimal("12000")
  end
  
  it "should be allowed to create ExchangeRate" do
    exr = ExchangeRate.create_object(
      :exchange_id => @exc_1.id,
      :ex_rate_date => @ex_rate_date_1,
      :rate => @rate_1
      )
    exr.should be_valid
    exr.errors.size.should == 0 
  end
  
  it "should not create if exchange_id is not valid" do
    exr = ExchangeRate.create_object(
      :exchange_id => nil,
      :ex_rate_date => @ex_rate_date_1,
      :rate => @rate_1  
      )
    exr.errors.size.should_not == 0 
    exr.should_not be_valid
  end 
  
  it "should not create if ex_rate_date is not valid" do
    exr = ExchangeRate.create_object(
      :exchange_id => @exc_1.id,
      :ex_rate_date => nil,
      :rate => @rate_1  
      )
    exr.errors.size.should_not == 0 
    exr.should_not be_valid
  end
  
  it "should not create if rate is not valid" do
    exr = ExchangeRate.create_object(
      :exchange_id => @exc_1.id,
      :ex_rate_date => @ex_rate_date_1,
      :rate => nil 
      )
    exr.errors.size.should_not == 0 
    exr.should_not be_valid
  end
  
  context "create ExchangeRate" do
    before(:each) do 
      @exr_1 = ExchangeRate.create_object(
        :exchange_id => @exc_1.id,
        :ex_rate_date => @ex_rate_date_1,
        :rate => @rate_1
      )
    end
  
    it "should update ExchangeRate" do
      @exr_1.update_object(
        :exchange_id => @exc_2.id,
        :ex_rate_date => @ex_rate_date_2,
        :rate => @rate_2
      )
      @exr_1.errors.size.should == 0
      @exr_1.exchange_id.should == @exc_2.id
      @exr_1.ex_rate_date.should == @ex_rate_date_2
      @exr_1.rate.should == @rate_2
    end
    
    it "should not update ExchangeRate if exchange_id is not valid" do
      @exr_1.update_object(
        :exchange_id => 1233412,
        :ex_rate_date => @ex_rate_date_2,
        :rate => @rate_2
      )
      @exr_1.errors.size.should_not == 0
    end
    
    it "should not update ExchangeRate if ex_rate_date is not valid" do
      @exr_1.update_object(
        :exchange_id => @exc_2.id,
        :ex_rate_date => nil,
        :rate => @rate_2
      )
      @exr_1.errors.size.should_not == 0
    end
        
    it "should not create another ExchangeRate with same exchange_id & ex_rate_date" do
      @exr_2 = ExchangeRate.create_object(
        :exchange_id => @exc_1.id,
        :ex_rate_date => @ex_rate_date_1,
        :rate => @rate_2
      )   
      @exr_2.errors.size.should_not == 0
    end
    
    it "should delete exchange" do
      @exr_1.delete_object
      ExchangeRate.count.should == 0
    end
    
    context "Create Second ExchangeRate" do
      before(:each) do
        @exr_2 = ExchangeRate.create_object(
        :exchange_id => @exc_2.id,
        :ex_rate_date => @ex_rate_date_2,
        :rate => @rate_2
      )   
      end
      
      it "should not update with same exchange_id & ex_rate_date" do
        @exr_2.update_object(
        :exchange_id => @exc_1.id,
        :ex_rate_date => @ex_rate_date_1,
        :rate => @rate_2
      )
      @exr_2.errors.size.should_not == 0
      end
    end
    
  end
end
