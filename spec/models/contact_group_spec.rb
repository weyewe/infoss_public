require 'spec_helper'

describe ContactGroup do
   
  before (:each) do
    @name_1 = "contactgroup1"
    @name_2 = "contactgroup2"
    @description_1 = "description1"
    @description_2 = "description2"
   
  end
  
  it "should be allowed to create contactgroup" do
    cg = ContactGroup.create_object(
      :name => @name_1,
      :description => @description_1
    )
    
    cg.should be_valid
    cg.errors.size.should == 0 
  end
  
  it "should not create object without name" do
    cg = ContactGroup.create_object(
      :name => nil ,
      :description => @description_1
      )
    
    cg.errors.size.should_not == 0 
    cg.should_not be_valid
    
  end
  
  it "should create object if name present, but length == 0 " do
    cg = ContactGroup.create_object(
       :name => "" ,
       :description => @description_1
    )
    
    cg.errors.size.should_not == 0 
    cg.should_not be_valid
    
  end
  
  
  context "Create New ContactGroup" do
    before (:each) do
      @cg = ContactGroup.create_object(
        :name => @name_1 ,
        :description => @description_1
      )
    end
    
    it "should create contactgroup" do
      @cg.errors.size.should == 0
      @cg.should be_valid
    end
    
    it "cannot update object if name not valid" do
     @cg.update_object(
        :name => nil,
        :description => @description_1
     )
     @cg.errors.size.should_not == 0 
     @cg.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @cg.update_object(
       :name => "",
       :description => @description_1
     )
     @cg.errors.size.should_not == 0 
     @cg.should_not be_valid
    end   
    
    it "should update object" do
      @cg.update_object(
       :name => @name_2 ,
       :description => @description_2
      )
      @cg.name.should == @name_2
      @cg.description.should == @description_2
    end
  
    it "should delete object" do
      @cg.delete_object
      ContactGroup.count.should == 0
    end
  end
end
