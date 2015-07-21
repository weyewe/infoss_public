require 'spec_helper'

describe Machine do
  before(:each) do
    @code_1 = "code_1"
    @code_2 = "code_2"
    @name_1 = "name_1"
    @name_2 = "name_2"
    @description_1 = "description_1"
    @description_2 = "description_2"
  end
  
  it "should not create object if code is valid" do
    machine = Machine.create_object(
      :code => nil,
      :name => @name_1,
      :description => @description_1
      )
    machine.errors.size.should_not == 0 
    machine.should_not be_valid
  end

  it "cannot update object if code present, but lenght == 0" do
    machine = Machine.create_object(
      :code => "",
      :name => @name_1,
      :description => @description_1
      )
    machine.errors.size.should_not == 0 
    machine.should_not be_valid
  end
  
  it "should not create object if name is valid" do
    machine = Machine.create_object(
      :code => @code_1,
      :name => nil,
      :description => @description_1
      )
    machine.errors.size.should_not == 0 
    machine.should_not be_valid
  end
  
  it "cannot update object if name present, but lenght == 0" do
    machine = Machine.create_object(
      :code => @code_1,
      :name => "",
      :description => @description_1
      )
    machine.errors.size.should_not == 0 
    machine.should_not be_valid
  end  
  
  context "Create New Machine" do
    before (:each) do
      @machine = Machine.create_object(
        :code => @code_1,
        :name => @name_1,
        :description => @description_1
        )
    end
    
    it "should create Machine" do
      @machine.errors.size.should == 0
      @machine.should be_valid
    end
    
    it "cannot update object if code not valid" do
      @machine.update_object(
        :code => nil,
        :name => @name_2,
        :description => @description_2
      )
      @machine.errors.size.should_not == 0 
      @machine.should_not be_valid
    end
    
    it "cannot update object if code present, but lenght == 0" do
     @machine.update_object(
       :code => "",
       :name => @name_2,
       :description => @description_2
     )
     @machine.errors.size.should_not == 0 
     @machine.should_not be_valid
    end   
    
    it "cannot update object if name not valid" do
      @machine.update_object(
        :code => @code_2,
        :name => nil,
        :description => @description_2
       )
       @machine.errors.size.should_not == 0 
       @machine.should_not be_valid
    end
    
    it "cannot update object if name present, but lenght == 0" do
     @machine.update_object(
       :code => @code_2,
       :name => "",
       :description => @description_2
     )
     @machine.errors.size.should_not == 0 
     @machine.should_not be_valid
    end   
    
    it "should update object" do
      @machine.update_object(
        :code => @code_2,
        :name => @name_2,
        :description => @description_2
      )
      @machine.code.should == @code_2
      @machine.name.should == @name_2
      @machine.description.should == @description_2
    end
  
    it "should delete object" do
      @machine.delete_object
      Machine.count.should == 0
    end
  end
  
  
end
