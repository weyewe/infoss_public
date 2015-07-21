require 'spec_helper'

describe Uom do
  
  before (:each) do
    @name_1 = "uom1"
    @name_2 = "uom2"
   
  end
  
  it "should be allowed to create uom" do
    uom = Uom.create_object(
      :name => @name_1,
     
    )
    
    uom.should be_valid
    uom.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    uom = Uom.create_object(
      :name => nil ,
     
      )
    
    uom.errors.size.should_not == 0 
    uom.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    uom = Uom.create_object(
       :name => "" ,
      
    )
    
    uom.errors.size.should_not == 0 
    uom.should_not be_valid
    
  end
  
  
  context "Create New Uom" do
    before (:each) do
      @uom = Uom.create_object(
        :name => @name_1 ,
       
      )
    end
    
    it "should create uom" do
      @uom.errors.size.should == 0
      @uom.should be_valid
    end
    
    it "cannot update object if name not valid" do
     @uom.update_object(
        :name => nil,
       
     )
     @uom.errors.size.should_not == 0 
     @uom.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @uom.update_object(
       :name => "",
      
     )
     @uom.errors.size.should_not == 0 
     @uom.should_not be_valid
    end   
    
    it "should update object" do
      @uom.update_object(
       :name => @name_2 ,
      )
      @uom.name.should == @name_2
    end
  
    it "should delete object" do
      @uom.delete_object
      Uom.count.should == 0
    end
  end
  
  
end
