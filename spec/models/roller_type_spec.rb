require 'spec_helper'

describe RollerType do
  before(:each) do
    @name_1 = "name_1"
    @name_2 = "name_2"
    @description_1 = "description_1"
    @description_2 = "description_2"
  end
  
  it "should not create object if name is valid" do
    roller_type = RollerType.create_object(
      :name => nil,
      :description => @description_1
      )
    roller_type.errors.size.should_not == 0 
    roller_type.should_not be_valid
  end
  
  it "cannot update object if name present, but lenght == 0" do
    roller_type = RollerType.create_object(
      :name => "",
      :description => @description_1
      )
    roller_type.errors.size.should_not == 0 
    roller_type.should_not be_valid
  end  
  
  context "Create New RollerType" do
    before (:each) do
      @roller_type = RollerType.create_object(
        :name => @name_1,
        :description => @description_1
        )
    end
    
    it "should create RollerType" do
      @roller_type.errors.size.should == 0
      @roller_type.should be_valid
    end
    
    it "cannot update object if name not valid" do
      @roller_type.update_object(
        :name => nil,
        :description => @description_2
       )
       @roller_type.errors.size.should_not == 0 
       @roller_type.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @roller_type.update_object(
       :name => "",
       :description => @description_2
     )
     @roller_type.errors.size.should_not == 0 
     @roller_type.should_not be_valid
    end   
    
    it "should update object" do
      @roller_type.update_object(
        :name => @name_2,
        :description => @description_2
      )
      @roller_type.name.should == @name_2
      @roller_type.description.should == @description_2
    end
  
    it "should delete object" do
      @roller_type.delete_object
      RollerType.count.should == 0
    end
  end
end
